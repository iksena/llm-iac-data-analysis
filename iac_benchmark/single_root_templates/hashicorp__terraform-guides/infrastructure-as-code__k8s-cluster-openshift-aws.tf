# ── main.tf ────────────────────────────────────
terraform {
  required_version = ">= 0.11.11"
}


# Set VAULT_TOKEN environment variable
provider "vault" {
  address = "${var.vault_addr}"
  max_lease_ttl_seconds = 7200
}

# AWS credentials from Vault
# Must set up AWS backend in Vault on path aws with role deploy
data "vault_aws_access_credentials" "aws_creds" {
  backend = "aws-tf"
  role = "deploy"
}

# Insert 15 second delay so AWS credentials definitely available
# at all AWS endpoints
data "external" "region" {
  # Delay so that new keys are available across AWS
  program = ["./delay-vault-aws", "${var.region}"]
}

# Vault Kubernetes Auth Backend
resource "vault_auth_backend" "k8s" {
  type = "kubernetes"
  path = "${var.vault_k8s_auth_path}"
  description = "Vault Auth Backend for OpenShift"
}

#  Setup the core provider information.
provider "aws" {
  access_key = "${data.vault_aws_access_credentials.aws_creds.access_key}"
  secret_key = "${data.vault_aws_access_credentials.aws_creds.secret_key}"
  region  = "${data.external.region.result["region"]}"
  version = "~> 2.0"
}

#  Create the OpenShift cluster using our module.
module "openshift" {
  source          = "./modules/openshift"
  region          = "${var.region}"
  amisize         = "t2.large" //  Smallest that meets OS specs
  vpc_cidr        = "${var.vpc_cidr}"
  subnet_cidr     = "${var.subnet_cidr}"
  subnetaz        = "${var.subnetaz}"
  key_name        = "${var.key_name}"
  private_key_data = "${var.private_key_data}"
  name_tag_prefix = "${var.vault_user}"
  owner           = "${var.owner}"
  ttl             = "${var.ttl}"
}

resource "null_resource" "post-install-master" {
  provisioner "remote-exec" {
    script = "${path.root}/scripts/postinstall-master.sh"
    connection {
      host = "${module.openshift.master_public_dns}"
      type = "ssh"
      agent = false
      user = "ec2-user"
      private_key = "${var.private_key_data}"
      bastion_host = "${module.openshift.bastion_public_dns}"
    }
  }
}

resource "null_resource" "post-install-node1" {
  provisioner "remote-exec" {
    script = "${path.root}/scripts/postinstall-node.sh"
    connection {
      host = "${module.openshift.node1_public_dns}"
      type = "ssh"
      agent = false
      user = "ec2-user"
      private_key = "${var.private_key_data}"
      bastion_host = "${module.openshift.bastion_public_dns}"
    }
  }
}

resource "null_resource" "get_config" {
  provisioner "remote-exec" {
    inline = [
      "scp -o StrictHostKeyChecking=no -i ~/.ssh/private-key.pem ec2-user@${module.openshift.master_public_dns}:~/.kube/config ~/config"
    ]

    connection {
      host = "${module.openshift.bastion_public_dns}"
      type = "ssh"
      agent = false
      user = "ec2-user"
      private_key = "${var.private_key_data}"
    }
  }

  provisioner "local-exec" {
    command = "echo \"${var.private_key_data}\" > private-key.pem"
  }

  provisioner "local-exec" {
    command = "chmod 400 private-key.pem"
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -i private-key.pem  ec2-user@${module.openshift.bastion_public_dns}:~/config config"
  }
  provisioner "local-exec" {
    command = "sed -n 4,4p config | cut -d ':' -f 2 | sed 's/ //' > ca_certificate"
  }
  provisioner "local-exec" {
    command = "sed -n 28,28p config | cut -d ':' -f 2 | sed 's/ //' > client_certificate"
  }
  provisioner "local-exec" {
    command = "sed -n 29,29p config | cut -d ':' -f 2 | sed 's/ //' > client_key"
  }

  depends_on = ["null_resource.post-install-master"]
}

resource "null_resource" "configure_k8s" {
  provisioner "file" {
    source = "vault-reviewer.yaml"
    destination = "~/vault-reviewer.yaml"
  }

  provisioner "file" {
    source = "vault-reviewer-rbac.yaml"
    destination = "~/vault-reviewer-rbac.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 180",
      "kubectl create -f vault-reviewer.yaml",
      "kubectl create -f vault-reviewer-rbac.yaml",
      "kubectl get serviceaccount vault-reviewer -o yaml > vault-reviewer-service.yaml",
      "kubectl get secret $(grep \"vault-reviewer-token\" vault-reviewer-service.yaml | cut -d ':' -f 2 | sed 's/ //') -o yaml > vault-reviewer-secret.yaml",
      "sed -n 6,6p vault-reviewer-secret.yaml | cut -d ':' -f 2 | sed 's/ //' | base64 -d > vault-reviewer-token"
    ]
  }

  connection {
    host = "${module.openshift.master_public_dns}"
    type = "ssh"
    agent = false
    user = "ec2-user"
    private_key = "${var.private_key_data}"
    bastion_host = "${module.openshift.bastion_public_dns}"
  }

  depends_on = ["null_resource.get_config"]

}

resource "null_resource" "get_vault_reviewer_token" {
  provisioner "remote-exec" {
    inline = [
      "scp -o StrictHostKeyChecking=no -i ~/.ssh/private-key.pem ec2-user@${module.openshift.master_public_dns}:~/vault-reviewer-token vault-reviewer-token"
    ]

    connection {
      host = "${module.openshift.bastion_public_dns}"
      type = "ssh"
      agent = false
      user = "ec2-user"
      private_key = "${var.private_key_data}"
    }
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -i private-key.pem  ec2-user@${module.openshift.bastion_public_dns}:~/vault-reviewer-token vault-reviewer-token"
  }

  depends_on = ["null_resource.configure_k8s"]
}

data "null_data_source" "get_certs" {
  inputs = {
    client_certificate = "${file("client_certificate")}"
    client_key = "${file("client_key")}"
    ca_certificate = "${file("ca_certificate")}"
    vault_reviewer_token = "${file("vault-reviewer-token")}"
  }
  depends_on = ["null_resource.get_vault_reviewer_token"]
}

# Use the vault_kubernetes_auth_backend_config resource
# instead of the a curl command in local-exec
resource "vault_kubernetes_auth_backend_config" "auth_config" {
  backend = "${vault_auth_backend.k8s.path}"
  kubernetes_host = "https://${module.openshift.master_public_ip}.xip.io:8443"
  kubernetes_ca_cert = "${chomp(base64decode(data.null_data_source.get_certs.outputs["ca_certificate"]))}"
  token_reviewer_jwt = "${data.null_data_source.get_certs.outputs["vault_reviewer_token"]}"
}

# Use vault_kubernetes_auth_backend_role instead of
# vault_generic_secret
resource "vault_kubernetes_auth_backend_role" "role" {
  backend = "${vault_auth_backend.k8s.path}"
  role_name = "demo"
  bound_service_account_names = ["cats-and-dogs"]
  bound_service_account_namespaces = ["default", "cats-and-dogs"]
  token_policies = ["${var.vault_user}"]
  token_ttl = 7200
}


# ── variables.tf ────────────────────────────────────
//  The region we will deploy our cluster into.
variable "region" {
  description = "Region to deploy the cluster into"
  default = "us-east-1"
}

variable "key_name" {
  description = "The name of the key to user for ssh access"
}

variable "private_key_data" {
  description = "contents of the private key"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "Subnet CIDR"
  default = "10.0.1.0/24"
}

//  This map defines which AZ to put the 'Public Subnet' in, based on the
//  region defined. You will typically not need to change this unless
//  you are running in a new region!
variable "subnetaz" {
  type = "map"

  default = {
    us-east-1 = "us-east-1a"
    us-east-2 = "us-east-2a"
    us-west-1 = "us-west-1a"
    us-west-2 = "us-west-2a"
    eu-west-1 = "eu-west-1a"
    eu-west-2 = "eu-west-2a"
    eu-central-1 = "eu-central-1a"
    ap-southeast-1 = "ap-southeast-1a"
  }
}

variable "owner" {
  description = "value set on EC2 owner tag"
  default = ""
}

variable "ttl" {
  description = "value set on EC2 TTL tag. -1 means forever. Measured in hours."
  default = "-1"
}

variable "vault_k8s_auth_path" {
  description = "The path of the Vault k8s auth backend"
  default = "openshift"
}

variable "vault_user" {
  description = "Vault userid: determines location of secrets and affects path of k8s auth backend"
}

variable "vault_addr" {
  description = "Address of Vault server including port"
}


# ── outputs.tf ────────────────────────────────────
# Output some useful variables for quick SSH access etc.
output "master_url" {
  value = "https://${module.openshift.master_public_ip}.xip.io:8443"
}
output "master_public_dns" {
  value = "${module.openshift.master_public_dns}"
}
output "master_public_ip" {
  value = "${module.openshift.master_public_ip}"
}
output "master_private_ip" {
  value = "${module.openshift.master_private_ip}"
}
output "bastion_public_dns" {
  value = "${module.openshift.bastion_public_dns}"
}
output "bastion_public_ip" {
  value = "${module.openshift.bastion_public_ip}"
}

output "k8s_endpoint" {
  value = "https://${module.openshift.master_public_ip}.xip.io:8443"
}

output "k8s_master_auth_client_certificate" {
  value = "${data.null_data_source.get_certs.outputs["client_certificate"]}"
}

output "k8s_master_auth_client_key" {
  value = "${data.null_data_source.get_certs.outputs["client_key"]}"
}

output "k8s_master_auth_cluster_ca_certificate" {
  value = "${data.null_data_source.get_certs.outputs["ca_certificate"]}"
}

output "vault_k8s_auth_backend" {
  value = "${vault_auth_backend.k8s.path}"
}

output "vault_user" {
  value = "${var.vault_user}"
}

output "vault_addr" {
  value = "${var.vault_addr}"
}
