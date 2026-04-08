output "ip_address" {
  description = "IP address of the Samba node"
  sensitive   = false
  value       = var.ip_address
}

output "vm_id" {
  description = "Identifier of the Samba VM in Proxmox"
  value       = proxmox_virtual_environment_vm.samba_node.id
}

output "smb_path" {
  description = "Filesystem path exported via Samba"
  value       = var.storage_path
}

output "ssh_credentials" {
  description = "SSH credentials for the Samba node"
  sensitive   = true
  value = {
    username        = local.samba_node.username
    ssh_private_key = tls_private_key.root_ssh.private_key_openssh
  }
}

output "admin_credentials" {
  description = "Samba admin user credentials"
  sensitive   = true
  value = {
    username = var.admin_user
    password = random_password.admin_password.result
  }
}
