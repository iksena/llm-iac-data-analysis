# https://developer.hashicorp.com/terraform/language/values/locals
locals {
  subdomain        = "${var.name}.${var.domain}"
  private_key_file = "${path.module}/${var.name}/key.pem"
  ssh_config_file  = "${path.module}/${var.name}/config"

  # X-UI configurations
  panel_port     = 80
  panel_username = "admin"
  panel_password = random_password.panel.result
}

# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
resource "random_password" "panel" {
  length  = 16
  lower   = true
  upper   = true
  numeric = true
  special = false
}
