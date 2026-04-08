# https://developer.hashicorp.com/terraform/language/values/locals
locals {
  subdomain        = "${var.name}.${var.domain}"
  private_key_file = "${path.module}/${var.name}/key.pem"
  ssh_config_file  = "${path.module}/${var.name}/config"
}
