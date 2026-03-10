# ── main.tf ────────────────────────────────────
data "aws_ami" "base" {
  most_recent = true
  owners      = ["${var.ami_owner}"]

  filter {
    name   = "name"
    values = ["${var.ami_name}"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "base_install" {
  template = "${file("${path.module}/../../templates/install-base.sh.tpl")}"
}

data "template_file" "consul_install" {
  template = "${file("${path.module}/../../templates/install-consul-systemd.sh.tpl")}"

  vars = {
    consul_version  = "${var.hashistack_consul_version}"
    consul_url      = "${var.hashistack_consul_url}"
    name            = "${var.name}"
    local_ip_url    = "${var.local_ip_url}"
    consul_override = false
    consul_config   = ""
  }
}

data "template_file" "vault_install" {
  template = "${file("${path.module}/../../templates/install-vault-systemd.sh.tpl")}"

  vars = {
    vault_version  = "${var.hashistack_vault_version}"
    vault_url      = "${var.hashistack_vault_url}"
    name           = "${var.name}"
    local_ip_url   = "${var.local_ip_url}"
    vault_override = false
    vault_config   = ""
  }
}

data "template_file" "nomad_install" {
  template = "${file("${path.module}/../../templates/install-nomad-systemd.sh.tpl")}"

  vars = {
    nomad_version  = "${var.hashistack_nomad_version}"
    nomad_url      = "${var.hashistack_nomad_url}"
    name           = "${var.name}"
    local_ip_url   = "${var.local_ip_url}"
    nomad_override = false
    nomad_config   = ""
  }
}

data "template_file" "bastion_quick_start" {
  template = "${file("${path.module}/../../templates/quick-start-bastion-systemd.sh.tpl")}"

  vars = {
    name            = "${var.name}"
    provider        = "${var.provider}"
    local_ip_url    = "${var.local_ip_url}"
    consul_override = "${var.consul_client_config_override != "" ? true : false}"
    consul_config   = "${var.consul_client_config_override}"
  }
}

module "network_aws" {
  source = "github.com/hashicorp-modules/network-aws"

  name              = "${var.name}"
  vpc_cidr          = "${var.vpc_cidr}"
  vpc_cidrs_public  = "${var.vpc_cidrs_public}"
  vpc_cidrs_private = "${var.vpc_cidrs_private}"
  nat_count         = "${var.nat_count}"
  bastion_count     = "${var.bastion_servers}"
  instance_type     = "${var.bastion_instance}"
  os                = "${replace(lower(var.ami_name), "ubuntu", "") != lower(var.ami_name) ? "Ubuntu" : replace(lower(var.ami_name), "rhel", "") != lower(var.ami_name) ? "RHEL" : "unknown"}"
  image_id          = "${var.bastion_image_id != "" ? var.bastion_image_id : data.aws_ami.base.id}"
  tags              = "${var.network_tags}"
  user_data         = <<EOF
${data.template_file.base_install.rendered} # Runtime install base tools
${data.template_file.consul_install.rendered} # Runtime install Consul in -dev mod
${data.template_file.vault_install.rendered} # Runtime install Vault in -dev mode
${data.template_file.nomad_install.rendered} # Runtime install Nomad in -dev mod
${data.template_file.bastion_quick_start.rendered} # Configure Bastion quick start
EOF
}

data "template_file" "hashistack_quick_start" {
  template = "${file("${path.module}/../../templates/quick-start-hashistack-systemd.sh.tpl")}"

  vars = {
    name             = "${var.name}"
    provider         = "${var.provider}"
    local_ip_url     = "${var.local_ip_url}"
    consul_bootstrap = "${var.hashistack_servers != -1 ? var.hashistack_servers : length(module.network_aws.subnet_private_ids)}"
    consul_override  = "${var.consul_server_config_override != "" ? true : false}"
    consul_config    = "${var.consul_server_config_override}"
    vault_override   = "${var.vault_config_override != "" ? true : false}"
    vault_config     = "${var.vault_config_override}"
    nomad_bootstrap  = "${var.hashistack_servers != -1 ? var.hashistack_servers : length(module.network_aws.subnet_private_ids)}"
    nomad_override   = "${var.nomad_config_override != "" ? true : false}"
    nomad_config     = "${var.nomad_config_override}"
  }
}

data "template_file" "docker_install" {
  template = "${file("${path.module}/../../templates/install-docker.sh.tpl")}"
}

data "template_file" "java_install" {
  template = "${file("${path.module}/../../templates/install-java.sh.tpl")}"
}

module "hashistack_aws" {
  source = "github.com/hashicorp-modules/hashistack-aws"

  name          = "${var.name}" # Must match network_aws module name for Consul Auto Join to work
  vpc_id        = "${module.network_aws.vpc_id}"
  vpc_cidr      = "${module.network_aws.vpc_cidr}"
  subnet_ids    = "${split(",", var.hashistack_public ? join(",", module.network_aws.subnet_public_ids) : join(",", module.network_aws.subnet_private_ids))}"
  count         = "${var.hashistack_servers}"
  instance_type = "${var.hashistack_instance}"
  os            = "${replace(lower(var.ami_name), "ubuntu", "") != lower(var.ami_name) ? "Ubuntu" : replace(lower(var.ami_name), "rhel", "") != lower(var.ami_name) ? "RHEL" : "unknown"}"
  image_id      = "${var.hashistack_image_id != "" ? var.hashistack_image_id : data.aws_ami.base.id}"
  public        = "${var.hashistack_public}"
  ssh_key_name  = "${module.network_aws.ssh_key_name}"
  tags          = "${var.hashistack_tags}"
  tags_list     = "${var.hashistack_tags_list}"
  user_data     = <<EOF
${data.template_file.base_install.rendered} # Runtime install base tools
${data.template_file.consul_install.rendered} # Runtime install Consul in -dev mode
${data.template_file.vault_install.rendered} # Runtime install Vault in -dev mode
${data.template_file.nomad_install.rendered} # Runtime install Nomad in -dev mode
${data.template_file.hashistack_quick_start.rendered} # Configure HashiStack quick start
${var.nomad_client_docker_install ? data.template_file.docker_install.rendered : "echo \"Skip Docker install\""} # Runtime install Docker
${var.nomad_client_java_install ? data.template_file.java_install.rendered : "echo \"Skip Java install\""} # Runtime install Java
EOF
}


# ── variables.tf ────────────────────────────────────
# ---------------------------------------------------------------------------------------------------------------------
# General Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "name"         { default = "hashistack-quick-start" }
variable "ami_owner"    { default = "309956199498" } # Base RHEL owner
variable "ami_name"     { default = "*RHEL-7.3_HVM_GA-*" } # Base RHEL name
variable "provider"     { default = "aws" }
variable "local_ip_url" { default = "http://169.254.169.254/latest/meta-data/local-ipv4" }

# ---------------------------------------------------------------------------------------------------------------------
# Network Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "vpc_cidr" { default = "10.139.0.0/16" }

variable "vpc_cidrs_public" {
  type    = "list"
  default = ["10.139.1.0/24", "10.139.2.0/24", "10.139.3.0/24",]
}

variable "vpc_cidrs_private" {
  type    = "list"
  default = ["10.139.11.0/24", "10.139.12.0/24", "10.139.13.0/24",]
}

variable "nat_count"        { default = 1 }
variable "bastion_servers"  { default = 1 }
variable "bastion_instance" { default = "t2.micro" }
variable "bastion_image_id" { default = "" }

variable "network_tags" {
  type    = "map"
  default = { }
}

# ---------------------------------------------------------------------------------------------------------------------
# HashiStack Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "hashistack_servers"        { default = -1 }
variable "hashistack_instance"       { default = "t2.micro" }
variable "hashistack_consul_version" { default = "1.2.3" }
variable "hashistack_vault_version"  { default = "0.11.3" }
variable "hashistack_nomad_version"  { default = "0.8.6" }
variable "hashistack_consul_url"     { default = "" }
variable "hashistack_vault_url"      { default = "" }
variable "hashistack_nomad_url"      { default = "" }
variable "hashistack_image_id"       { default = "" }

variable "hashistack_public" {
  description = "If true, assign a public IP, open port 22 for public access, & provision into public subnets to provide easier accessibility without a Bastion host - DO NOT DO THIS IN PROD"
  default     = true
}

variable "consul_server_config_override" { default = "" }
variable "consul_client_config_override" { default = "" }
variable "vault_config_override"         { default = "" }
variable "nomad_config_override"         { default = "" }
variable "nomad_client_docker_install"   { default = true }
variable "nomad_client_java_install"     { default = true }

variable "hashistack_tags" {
  type    = "map"
  default = { }
}

variable "hashistack_tags_list" {
  type    = "list"
  default = [ ]
}


# ── outputs.tf ────────────────────────────────────
output "zREADME" {
  value = <<README

Your "${var.name}" AWS Nomad Quick Start cluster has been
successfully provisioned!

${module.network_aws.zREADME}
# ------------------------------------------------------------------------------
# Local HTTP API Requests
# ------------------------------------------------------------------------------

If you're making HTTP API requests outside the Bastion (locally), set
the below env vars.

The `hashistack_public` variable must be set to true for requests to work.

`hashistack_public`: ${var.hashistack_public}

  $ export NOMAD_ADDR=http://${module.hashistack_aws.nomad_lb_dns}:4646
  $ export VAULT_ADDR=http://${module.hashistack_aws.vault_lb_dns}:8200
  $ export CONSUL_ADDR=http://${module.hashistack_aws.consul_lb_dns}:8500

# ------------------------------------------------------------------------------
# Nomad Quick Start
# ------------------------------------------------------------------------------

Once on the Bastion host, you can use Consul's DNS functionality to seamlessly
SSH into other Consul or Nomad nodes if they exist.

  $ ssh -A ${module.hashistack_aws.hashistack_username}@nomad.service.consul
  $ ssh -A ${module.hashistack_aws.hashistack_username}@nomad-client.service.consul
  $ ssh -A ${module.hashistack_aws.hashistack_username}@consul.service.consul

  # Vault must be initialized & unsealed for this command to work
  $ ssh -A ${module.hashistack_aws.hashistack_username}@vault.service.consul

${module.hashistack_aws.zREADME}
# ------------------------------------------------------------------------------
# Nomad Quick Start - Vault Integration
# ------------------------------------------------------------------------------

The Vault integration for Nomad can be enabled by initializing Vault
and running the below commands.

  $ export VAULT_TOKEN=<ROOT_TOKEN>
  $ consul exec -node ${var.name}-server-nomad - <<EOF
echo "VAULT_TOKEN=$VAULT_TOKEN" | sudo tee -a /etc/nomad.d/nomad.conf

cat <<CONFIG | sudo tee /etc/nomad.d/z-vault.hcl
vault {
  enabled = true
  address = "http://vault.service.consul:8200"

  tls_skip_verify = true
}
CONFIG

sudo systemctl restart nomad
EOF

  $ consul exec -node ${var.name}-client-nomad - <<EOF
cat <<CONFIG | sudo tee /etc/nomad.d/z-vault.hcl
vault {
  enabled = true
  address = "http://vault.service.consul:8200"

  tls_skip_verify = true
}
CONFIG

sudo systemctl restart nomad
EOF
README
}

output "vpc_cidr" {
  value = "${module.network_aws.vpc_cidr}"
}

output "vpc_id" {
  value = "${module.network_aws.vpc_id}"
}

output "subnet_public_ids" {
  value = "${module.network_aws.subnet_public_ids}"
}

output "subnet_private_ids" {
  value = "${module.network_aws.subnet_private_ids}"
}

output "bastion_security_group" {
  value = "${module.network_aws.bastion_security_group}"
}

output "bastion_ips_public" {
  value = "${module.network_aws.bastion_ips_public}"
}

output "bastion_username" {
  value = "${module.network_aws.bastion_username}"
}

output "private_key_name" {
  value = "${module.network_aws.private_key_name}"
}

output "private_key_filename" {
  value = "${module.network_aws.private_key_filename}"
}

output "private_key_pem" {
  value = "${module.network_aws.private_key_pem}"
}

output "public_key_pem" {
  value = "${module.network_aws.public_key_pem}"
}

output "public_key_openssh" {
  value = "${module.network_aws.public_key_openssh}"
}

output "ssh_key_name" {
  value = "${module.network_aws.ssh_key_name}"
}

output "hashistack_asg_id" {
  value = "${module.hashistack_aws.hashistack_asg_id}"
}

output "consul_sg_id" {
  value = "${module.hashistack_aws.consul_sg_id}"
}

output "consul_lb_sg_id" {
  value = "${module.hashistack_aws.consul_lb_sg_id}"
}

output "consul_tg_http_8500_arn" {
  value = "${module.hashistack_aws.consul_tg_http_8500_arn}"
}

output "consul_lb_dns" {
  value = "${module.hashistack_aws.consul_lb_dns}"
}

output "vault_sg_id" {
  value = "${module.hashistack_aws.vault_sg_id}"
}

output "vault_lb_sg_id" {
  value = "${module.hashistack_aws.vault_lb_sg_id}"
}

output "vault_tg_http_8200_arn" {
  value = "${module.hashistack_aws.vault_tg_http_8200_arn}"
}

output "vault_lb_dns" {
  value = "${module.hashistack_aws.vault_lb_dns}"
}

output "nomad_sg_id" {
  value = "${module.hashistack_aws.nomad_sg_id}"
}

output "nomad_lb_sg_id" {
  value = "${module.hashistack_aws.nomad_lb_sg_id}"
}

output "nomad_tg_http_4646_arn" {
  value = "${module.hashistack_aws.nomad_tg_http_4646_arn}"
}

output "nomad_lb_dns" {
  value = "${module.hashistack_aws.nomad_lb_dns}"
}


# ── gitignore.tf ────────────────────────────────────
# `.tf` files that contain the word "gitignore" are ignored
# by git in the `.gitignore` file at the root of this repo.

# If you have local Terraform configuration that you want
# ignored like Terraform backend configuration, create
# a new file (separate from this one) that contains the
# word "gitignore" (e.g. `backend.gitignore.tf`).
