output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_cidrs" {
  value = var.public_subnet_cidrs
}

output "private_subnet_cidrs" {
  value = var.private_subnet_cidrs
}

output "account_id" {
  value = data.aws_caller_identity.current.id
}