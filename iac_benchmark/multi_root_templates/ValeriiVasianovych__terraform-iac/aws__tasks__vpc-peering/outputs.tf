output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "vpc_peering_id" {
  value = aws_vpc_peering_connection.vpc_peering.id
}

# VPC-1
output "vpc_1_cidr" {
  value = aws_vpc.vpc-1.cidr_block
}

output "vpc_1_id" {
  value = aws_vpc.vpc-1.id
}

output "subnet_1_cidr" {
  value = aws_subnet.subnet-1.cidr_block
}

# VPC-2
output "vpc_2_cidr" {
  value = aws_vpc.vpc-2.cidr_block
}

output "vpc_2_id" {
  value = aws_vpc.vpc-2.id
}

output "subnet_2_cidr" {
  value = aws_subnet.subnet-2.cidr_block
}