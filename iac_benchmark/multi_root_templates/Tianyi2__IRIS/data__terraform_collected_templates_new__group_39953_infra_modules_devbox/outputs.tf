output "ip_address" {
  description = "IP address of the devbox node"
  sensitive   = false
  value       = var.ip_address
}

output "vm_id" {
  description = "Identifier of the devbox VM in Proxmox"
  value       = proxmox_virtual_environment_vm.devbox_node.id
}

output "ssh_credentials" {
  description = "SSH credentials for the devbox node"
  sensitive   = true
  value = {
    username        = var.admin_user
    ssh_private_key = tls_private_key.root_ssh.private_key_openssh
  }
}

output "admin_credentials" {
  description = "devbox admin user credentials"
  sensitive   = true
  value = {
    username = var.admin_user
    password = random_password.admin_password.result
  }
}
