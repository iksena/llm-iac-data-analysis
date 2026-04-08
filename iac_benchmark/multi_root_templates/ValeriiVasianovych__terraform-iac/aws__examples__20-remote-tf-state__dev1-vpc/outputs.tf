output "vpc_id" {
   value = aws_vpc.main
}

output "public_subnet_ids" {
    value = aws_subnet.public_subnet[*].id
}

output "owner" {
    value = data.aws_caller_identity.current.account_id
}