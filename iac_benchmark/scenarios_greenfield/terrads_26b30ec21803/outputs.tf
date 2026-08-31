output "consul_security_group_id" {
	value = aws_security_group.hcp_consul.id
}

output "vault_security_group_id" {
	value = aws_security_group.hcp_vault.id
}