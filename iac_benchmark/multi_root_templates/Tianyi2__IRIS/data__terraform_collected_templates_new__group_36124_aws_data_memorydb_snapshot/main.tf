data "aws_memorydb_snapshot" "this" {
  region = var.region
  name   = var.name
}