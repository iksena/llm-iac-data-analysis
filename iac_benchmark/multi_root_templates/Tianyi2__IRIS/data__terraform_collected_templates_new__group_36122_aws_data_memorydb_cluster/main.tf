data "aws_memorydb_cluster" "this" {
  region = var.region
  name   = var.name
}