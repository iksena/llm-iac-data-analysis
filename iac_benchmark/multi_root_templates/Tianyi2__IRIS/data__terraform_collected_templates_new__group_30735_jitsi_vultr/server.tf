# https://registry.terraform.io/providers/vultr/vultr/latest/docs
provider "vultr" {
  api_key = var.vultr_api_key
}

# https://registry.terraform.io/providers/vultr/vultr/latest/docs/resources/instance
resource "vultr_instance" "server" {
  plan             = var.vultr_instance_plan   # https://api.vultr.com/v2/plans
  region           = var.vultr_instance_region # https://api.vultr.com/v2/regions
  os_id            = var.vultr_instance_os     # https://api.vultr.com/v2/os
  hostname         = var.name
  ssh_key_ids      = [vultr_ssh_key.server.id]
  user_data        = file("${path.module}/user-data.sh")
  backups          = "disabled"
  enable_ipv6      = true
  ddos_protection  = false
  activation_email = false
  label            = var.name
  tags             = ["server", "jitis"]

  # https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax
  # https://developer.hashicorp.com/terraform/language/resources/provisioners/connection
  # https://developer.hashicorp.com/terraform/language/resources/provisioners/file

  connection {
    type        = "ssh"
    user        = "root"
    host        = self.main_ip
    private_key = file(local.private_key_file)
  }

  # Set domain name as hostname
  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname ${local.subdomain}",
      "echo '' >> /etc/hosts",
      "echo '# Jitsi hostname' >> /etc/hosts",
      "echo '${self.main_ip} ${local.subdomain}' >> /etc/hosts",
    ]
  }

  # Configure firewall rules
  provisioner "remote-exec" {
    inline = [
      "sudo ufw allow 22/tcp",
      "sudo ufw allow 80/tcp",
      "sudo ufw allow 443/tcp",
      "sudo ufw allow 3478/udp",
      "sudo ufw allow 5349/tcp",
      "sudo ufw allow 10000/udp",
      "yes | sudo ufw enable",
      "sudo ufw reload",
    ]
  }
}

# https://registry.terraform.io/providers/vultr/vultr/latest/docs/resources/ssh_key
resource "vultr_ssh_key" "server" {
  name    = var.name
  ssh_key = tls_private_key.server.public_key_openssh
}

# https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key
resource "tls_private_key" "server" {
  algorithm = "ED25519"
}

# https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file
resource "local_sensitive_file" "private_key" {
  filename             = local.private_key_file
  content              = tls_private_key.server.private_key_openssh
  file_permission      = "400"
  directory_permission = "700"
}

# https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file
resource "local_file" "ssh_config" {
  filename             = local.ssh_config_file
  content              = data.template_file.ssh_config.rendered
  file_permission      = "600"
  directory_permission = "700"
}

# https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file
data "template_file" "ssh_config" {
  template = file("${path.module}/ssh-config.tpl")
  vars = {
    name             = var.name
    address          = vultr_instance.server.main_ip
    private_key_file = basename(local.private_key_file)
  }
}
