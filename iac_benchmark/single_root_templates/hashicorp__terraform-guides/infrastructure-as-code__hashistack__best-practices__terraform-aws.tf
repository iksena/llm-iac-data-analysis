# ── main.tf ────────────────────────────────────
module "ssh_keypair_aws_override" {
  source = "github.com/hashicorp-modules/ssh-keypair-aws"

  name = "${var.name}-override"
}

module "consul_auto_join_instance_role" {
  source = "github.com/hashicorp-modules/consul-auto-join-instance-role-aws"

  name = "${var.name}"
}

resource "random_id" "consul_encrypt" {
  byte_length = 16
}

resource "random_id" "nomad_encrypt" {
  byte_length = 16
}

module "root_tls_self_signed_ca" {
   source = "github.com/hashicorp-modules/tls-self-signed-cert"

  name              = "${var.name}-root"
  ca_common_name    = "${var.common_name}"
  organization_name = "${var.organization_name}"
  common_name       = "${var.common_name}"
  download_certs    = "${var.download_certs}"

  validity_period_hours = "8760"

  ca_allowed_uses = [
    "cert_signing",
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
  ]
}

module "leaf_tls_self_signed_cert" {
  source = "github.com/hashicorp-modules/tls-self-signed-cert"

  name              = "${var.name}-leaf"
  organization_name = "${var.organization_name}"
  common_name       = "${var.common_name}"
  ca_override       = true
  ca_key_override   = "${module.root_tls_self_signed_ca.ca_private_key_pem}"
  ca_cert_override  = "${module.root_tls_self_signed_ca.ca_cert_pem}"
  download_certs    = "${var.download_certs}"

  validity_period_hours = "8760"

  dns_names = [
    "localhost",
    "*.node.consul",
    "*.service.consul",
    "server.dc1.consul",
    "*.dc1.consul",
    "server.${var.name}.consul",
    "*.${var.name}.consul",
    "server.global.nomad",
    "*.global.nomad",
    "server.${var.name}.nomad",
    "*.${var.name}.nomad",
    "client.global.nomad",
    "*.global.nomad",
    "client.${var.name}.nomad",
    "*.${var.name}.nomad",
  ]

  ip_addresses = [
    "0.0.0.0",
    "127.0.0.1",
  ]

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
  ]
}

data "template_file" "bastion_user_data" {
  template = "${file("${path.module}/../../templates/best-practices-bastion-systemd.sh.tpl")}"

  vars = {
    name            = "${var.name}"
    provider        = "${var.provider}"
    local_ip_url    = "${var.local_ip_url}"
    ca_crt          = "${module.root_tls_self_signed_ca.ca_cert_pem}"
    leaf_crt        = "${module.leaf_tls_self_signed_cert.leaf_cert_pem}"
    leaf_key        = "${module.leaf_tls_self_signed_cert.leaf_private_key_pem}"
    consul_encrypt  = "${random_id.consul_encrypt.b64_std}"
    consul_override = "${var.consul_client_config_override != "" ? true : false}"
    consul_config   = "${var.consul_client_config_override}"
  }
}

module "network_aws" {
  source = "github.com/hashicorp-modules/network-aws"

  name              = "${var.name}"
  vpc_cidr          = "${var.vpc_cidr}"
  vpc_cidrs_public  = "${var.vpc_cidrs_public}"
  nat_count         = "${var.nat_count}"
  vpc_cidrs_private = "${var.vpc_cidrs_private}"
  release_version   = "${var.bastion_release}"
  consul_version    = "${var.bastion_consul_version}"
  vault_version     = "${var.bastion_vault_version}"
  nomad_version     = "${var.bastion_nomad_version}"
  os                = "${var.bastion_os}"
  os_version        = "${var.bastion_os_version}"
  bastion_count     = "${var.bastion_servers}"
  instance_profile  = "${module.consul_auto_join_instance_role.instance_profile_id}" # Override instance_profile
  instance_type     = "${var.bastion_instance}"
  image_id          = "${var.bastion_image_id}"
  user_data         = "${data.template_file.bastion_user_data.rendered}" # Override user_data
  ssh_key_name      = "${module.ssh_keypair_aws_override.name}"
  ssh_key_override  = true
  private_key_file  = "${module.ssh_keypair_aws_override.private_key_filename}"
  tags              = "${var.network_tags}"
}

data "template_file" "hashistack_best_practices" {
  template = "${file("${path.module}/../../templates/best-practices-hashistack-systemd.sh.tpl")}"

  vars = {
    name             = "${var.name}"
    provider         = "${var.provider}"
    local_ip_url     = "${var.local_ip_url}"
    ca_crt           = "${module.root_tls_self_signed_ca.ca_cert_pem}"
    leaf_crt         = "${module.leaf_tls_self_signed_cert.leaf_cert_pem}"
    leaf_key         = "${module.leaf_tls_self_signed_cert.leaf_private_key_pem}"
    consul_bootstrap = "${var.hashistack_servers != -1 ? var.hashistack_servers : length(module.network_aws.subnet_private_ids)}"
    consul_encrypt   = "${random_id.consul_encrypt.b64_std}"
    consul_override  = "${var.consul_server_config_override != "" ? true : false}"
    consul_config    = "${var.consul_server_config_override}"
    vault_encrypt    = "${random_id.consul_encrypt.b64_std}"
    vault_override   = "${var.vault_config_override != "" ? true : false}"
    vault_config     = "${var.vault_config_override}"
    nomad_bootstrap  = "${var.hashistack_servers != -1 ? var.hashistack_servers : length(module.network_aws.subnet_private_ids)}"
    nomad_encrypt    = "${random_id.nomad_encrypt.b64_std}"
    nomad_override   = "${var.nomad_config_override != "" ? true : false}"
    nomad_config     = "${var.nomad_config_override}"
  }
}

module "hashistack_aws" {
  source = "github.com/hashicorp-modules/hashistack-aws"

  name             = "${var.name}" # Must match network_aws module name for Consul Auto Join to work
  vpc_id           = "${module.network_aws.vpc_id}"
  vpc_cidr         = "${module.network_aws.vpc_cidr}"
  subnet_ids       = "${split(",", var.hashistack_public ? join(",", module.network_aws.subnet_public_ids) : join(",", module.network_aws.subnet_private_ids))}"
  release_version  = "${var.hashistack_release}"
  consul_version   = "${var.hashistack_consul_version}"
  vault_version    = "${var.hashistack_vault_version}"
  nomad_version    = "${var.hashistack_nomad_version}"
  os               = "${var.hashistack_os}"
  os_version       = "${var.hashistack_os_version}"
  count            = "${var.hashistack_servers}"
  instance_profile = "${module.consul_auto_join_instance_role.instance_profile_id}" # Override instance_profile
  instance_type    = "${var.hashistack_instance}"
  image_id         = "${var.hashistack_image_id}"
  public           = "${var.hashistack_public}"
  use_lb_cert      = true
  lb_cert          = "${module.leaf_tls_self_signed_cert.leaf_cert_pem}"
  lb_private_key   = "${module.leaf_tls_self_signed_cert.leaf_private_key_pem}"
  lb_cert_chain    = "${module.root_tls_self_signed_ca.ca_cert_pem}"
  user_data        = "${data.template_file.hashistack_best_practices.rendered}" # Custom user_data
  ssh_key_name     = "${module.ssh_keypair_aws_override.name}"
  tags             = "${var.hashistack_tags}"
  tags_list        = "${var.hashistack_tags_list}"
}


# ── variables.tf ────────────────────────────────────
# ---------------------------------------------------------------------------------------------------------------------
# General Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "name"              { default = "hashistack-best-practices" }
variable "common_name"       { default = "example.com" }
variable "organization_name" { default = "Example Inc." }
variable "provider"          { default = "aws" }
variable "local_ip_url"      { default = "http://169.254.169.254/latest/meta-data/local-ipv4" }
variable "download_certs"    { default = false }

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

variable "nat_count"              { default = 1 }
variable "bastion_servers"        { default = 1 }
variable "bastion_instance"       { default = "t2.small" }
variable "bastion_release"        { default = "0.1.0" }
variable "bastion_consul_version" { default = "1.2.3" }
variable "bastion_vault_version"  { default = "0.11.3" }
variable "bastion_nomad_version"  { default = "0.8.6" }
variable "bastion_os"             { default = "RHEL" }
variable "bastion_os_version"     { default = "7.3" }
variable "bastion_image_id"       { default = "" }

variable "network_tags" {
  type    = "map"
  default = { }
}

# ---------------------------------------------------------------------------------------------------------------------
# HashiStack Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "hashistack_servers"        { default = -1 }
variable "hashistack_instance"       { default = "t2.small" }
variable "hashistack_release"        { default = "0.1.0" }
variable "hashistack_consul_version" { default = "1.2.3" }
variable "hashistack_vault_version"  { default = "0.11.3" }
variable "hashistack_nomad_version"  { default = "0.8.6" }
variable "hashistack_os"             { default = "RHEL" }
variable "hashistack_os_version"     { default = "7.3" }
variable "hashistack_image_id"       { default = "" }

variable "hashistack_public" {
  description = "If true, assign a public IP, open port 22 for public access, & provision into public subnets to provide easier accessibility without a Bastion host - DO NOT DO THIS IN PROD"
  default     = false
}

variable "consul_server_config_override" { default = "" }
variable "consul_client_config_override" { default = "" }

variable "vault_config_override" { default = "" }

variable "nomad_config_override" { default = "" }
variable "nomad_docker_install"  { default = true }
variable "nomad_java_install"    { default = true }

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

Your "${var.name}" AWS HashiStack Best Practices cluster has been
successfully provisioned!

${module.network_aws.zREADME}To force the generation of a new key, the private key instance can be "tainted"
using the below command.

  $ terraform taint -module=ssh_keypair_aws_override.tls_private_key \
      tls_private_key.key
${var.download_certs ?
"\n${module.root_tls_self_signed_ca.zREADME}
${module.leaf_tls_self_signed_cert.zREADME}
# ------------------------------------------------------------------------------
# Local HTTP API Requests
# ------------------------------------------------------------------------------

If you're making HTTPS API requests outside the Bastion (locally), set
the below env vars.

The `hashistack_public` variable must be set to true for requests to work.

`hashistack_public`: ${var.hashistack_public}

  $ export NOMAD_ADDR=https://${module.hashistack_aws.nomad_lb_dns}:4646
  $ export NOMAD_CACERT=./${module.leaf_tls_self_signed_cert.ca_cert_filename}
  $ export NOMAD_CLIENT_CERT=./${module.leaf_tls_self_signed_cert.leaf_cert_filename}
  $ export NOMAD_CLIENT_KEY=./${module.leaf_tls_self_signed_cert.leaf_private_key_filename}

  $ export VAULT_ADDR=https://${module.hashistack_aws.vault_lb_dns}:8200
  $ export VAULT_CACERT=./${module.leaf_tls_self_signed_cert.ca_cert_filename}
  $ export VAULT_CLIENT_CERT=./${module.leaf_tls_self_signed_cert.leaf_cert_filename}
  $ export VAULT_CLIENT_KEY=./${module.leaf_tls_self_signed_cert.leaf_private_key_filename}

  $ export CONSUL_ADDR=https://${module.hashistack_aws.consul_lb_dns}:8080 # HTTPS
  $ export CONSUL_ADDR=http://${module.hashistack_aws.consul_lb_dns}:8500 # HTTP
  $ export CONSUL_CACERT=./${module.leaf_tls_self_signed_cert.ca_cert_filename}
  $ export CONSUL_CLIENT_CERT=./${module.leaf_tls_self_signed_cert.leaf_cert_filename}
  $ export CONSUL_CLIENT_KEY=./${module.leaf_tls_self_signed_cert.leaf_private_key_filename}\n" : ""}
# ------------------------------------------------------------------------------
# HashiStack Best Practices
# ------------------------------------------------------------------------------

Once on the Bastion host, you can use Consul's DNS functionality to seamlessly
SSH into other HashiStack nodes if they exist.

  $ ssh -A ${module.hashistack_aws.hashistack_username}@nomad.service.consul
  $ ssh -A ${module.hashistack_aws.hashistack_username}@nomad-client.service.consul
  $ ssh -A ${module.hashistack_aws.hashistack_username}@consul.service.consul

  # Vault must be initialized & unsealed for this command to work
  $ ssh -A ${module.hashistack_aws.hashistack_username}@vault.service.consul

${module.hashistack_aws.zREADME}
# ------------------------------------------------------------------------------
# HashiStack Best Practices - Vault Integration
# ------------------------------------------------------------------------------

The Vault integration for Nomad can be enabled by initializing Vault and running
the below commands.

  $ export VAULT_TOKEN=<ROOT_TOKEN>
  $ consul exec -node ${var.name}-server-nomad - <<EOF
echo "VAULT_TOKEN=$VAULT_TOKEN" | sudo tee -a /etc/nomad.d/nomad.conf

cat <<CONFIG | sudo tee /etc/nomad.d/z-vault.hcl
vault {
  enabled = true
  address = "https://vault.service.consul:8200"

  ca_path   = "/opt/nomad/tls/vault-ca.crt"
  cert_file = "/opt/nomad/tls/vault.crt"
  key_file  = "/opt/nomad/tls/vault.key"
}
CONFIG

sudo systemctl restart nomad
EOF

  $ consul exec -node ${var.name}-client-nomad - <<EOF
cat <<CONFIG | sudo tee /etc/nomad.d/z-vault.hcl
vault {
  enabled = true
  address = "https://vault.service.consul:8200"

  ca_path   = "/opt/nomad/tls/vault-ca.crt"
  cert_file = "/opt/nomad/tls/vault.crt"
  key_file  = "/opt/nomad/tls/vault.key"
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
  value = "${module.ssh_keypair_aws_override.private_key_name}"
}

output "private_key_filename" {
  value = "${module.ssh_keypair_aws_override.private_key_filename}"
}

output "private_key_pem" {
  value = "${module.ssh_keypair_aws_override.private_key_pem}"
}

output "public_key_pem" {
  value = "${module.ssh_keypair_aws_override.public_key_pem}"
}

output "public_key_openssh" {
  value = "${module.ssh_keypair_aws_override.public_key_openssh}"
}

output "ssh_key_name" {
  value = "${module.ssh_keypair_aws_override.name}"
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

output "consul_tg_https_8080_arn" {
  value = "${module.hashistack_aws.consul_tg_https_8080_arn}"
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

output "vault_tg_https_8200_arn" {
  value = "${module.hashistack_aws.vault_tg_https_8200_arn}"
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

output "nomad_tg_https_4646_arn" {
  value = "${module.hashistack_aws.nomad_tg_https_4646_arn}"
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
