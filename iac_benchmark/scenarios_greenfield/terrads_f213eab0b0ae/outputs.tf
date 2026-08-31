output "vpc_id" {
  value = aws_vpc.financy_vpc.id
  description = "VPC created with id: "
}
output "internet_gateway_id" {
  value = aws_internet_gateway.financy_gateway.id
  description = "Internet gateway created with id: "
}
