output "region" {
  value = data.aws_region.current.description
}

output "account_id" {
  value = data.aws_caller_identity.current.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "vpc_cidr" {
  value = var.vpc_cidr
}

output "public_subnet_cidrs" {
  value = var.public_subnet_cidrs
}

output "private_subnet_cidrs" {
  value = var.private_subnet_cidrs
}