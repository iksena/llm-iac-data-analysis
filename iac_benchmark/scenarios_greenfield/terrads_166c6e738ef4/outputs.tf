output "out_vpc_id" {
  value = aws_vpc.webhost_vpc.id
}

output "out_vpc_rt_id" {
  value = aws_vpc.webhost_vpc.default_route_table_id
}

output "out_public_subnet_id" {
  value = aws_subnet.webhost_public_subnet.id
}

output "out_private_subnet_id" {
  value = aws_subnet.webhost_private_subnet.id
}

output "out_igw_id" {
  value = aws_internet_gateway.webhost_igw.id
}

output "out_public_rt_id" {
  value = aws_route_table.webhost_public_rt.id
}

output "out_private_rt_id" {
  value = aws_route_table.webhost_private_rt.id
}

output "out_ecs_cluster_id" {
  value = aws_ecs_cluster.webhost_ecs_cluster.id
}

/* output "out_ecr_repo_id" {
  value = aws_ecr_repository.webhost_ecr_repo.id
} */

output "out_natgw_eip_id" {
  value = aws_eip.webhost_natgw_eip.id
}