output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnets" {
  value = aws_subnet.private
}

output "public_subnets" {
  value = aws_subnet.public
}

output "private_subnet_ids" {
  value = values(aws_subnet.private)[*]["id"]
}

output "public_subnet_ids" {
  value = values(aws_subnet.public)[*]["id"]
}

output "private_subnet_arns" {
  value = values(aws_subnet.private)[*]["arn"]
}

output "public_subnet_arns" {
  value = values(aws_subnet.public)[*]["arn"]
}
