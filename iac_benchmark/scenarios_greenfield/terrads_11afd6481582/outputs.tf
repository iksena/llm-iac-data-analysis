output "network_interface_id" {
  value = aws_network_interface.network_interface.id
}
output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "security_group_id" {
  value = aws_security_group.security_group.id
}
