output "id" {
  value       = join("", azurerm_network_security_group.nsg[*].id)
  description = "The network security group configuration ID."
}

