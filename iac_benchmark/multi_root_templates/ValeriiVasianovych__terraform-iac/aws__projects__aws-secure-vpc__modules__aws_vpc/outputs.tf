output "region" {
  value = var.region
}

output "env" {
  value = var.env
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr_block" {
  value = aws_vpc.main.cidr_block
}

output "public_subnet_cidr_blocks" {
  value = length(aws_subnet.public_subnets) > 0 ? aws_subnet.public_subnets[*].cidr_block : []
}

output "public_subnet_ids" {
  value = length(aws_subnet.public_subnets) > 0 ? aws_subnet.public_subnets[*].id : []
}

output "private_subnet_cidr_blocks" {
  value = length(aws_subnet.private_subnets) > 0 ? aws_subnet.private_subnets[*].cidr_block : []
}

output "private_subnet_ids" {
  value = length(aws_subnet.private_subnets) > 0 ? aws_subnet.private_subnets[*].id : []
}

output "db_private_subnet_cidr_blocks" {
  value = length(aws_subnet.db_private_subnets) > 0 ? aws_subnet.db_private_subnets[*].cidr_block : []

}

output "db_private_subnet_ids" {
  value = length(aws_subnet.db_private_subnets) > 0 ? aws_subnet.db_private_subnets[*].id : []
}