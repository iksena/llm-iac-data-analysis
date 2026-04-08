output "security_group_id" {
  value       = module.network_security_group.id
  description = "Specifies the id of the network security group. Changing this forces a new resource to be created."
}