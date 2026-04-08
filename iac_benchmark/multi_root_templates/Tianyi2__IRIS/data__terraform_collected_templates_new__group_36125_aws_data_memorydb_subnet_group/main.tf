data "aws_memorydb_subnet_group" "this" {
  name   = var.name
  region = var.region
}