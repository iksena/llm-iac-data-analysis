output "vpc_main" {
  value       = aws_vpc.main.id
  description = "VPC id"
}

output "subnet_public_A" {
  value       = aws_subnet.public_a.id
  description = "Subnet public A"
}

output "subnet_public_B" {
  value       = aws_subnet.public_b.id
  description = "Subnet public B"
}

output "subnet_private_A" {
  value       = aws_subnet.private_a[0].id
  description = "Subnet private A"
}

output "subnet_private_B" {
  value       = aws_subnet.private_b[0].id
  description = "Subnet private B"
}

output "subnet_public_C" {
  value       = try(aws_subnet.public_c[0].id, null)
  description = "Subnet public C"
}

output "subnet_public_D" {
  value       = try(aws_subnet.public_d[0].id, null)
  description = "Subnet public D"
}

output "default_security_group"{
  value = aws_default_security_group.default.id
  description = "Default SG for VPC"
}

output "security_group_allow_tls"{
  value = aws_security_group.allow_tls.id
  description = "Default SG for VPC"
}
