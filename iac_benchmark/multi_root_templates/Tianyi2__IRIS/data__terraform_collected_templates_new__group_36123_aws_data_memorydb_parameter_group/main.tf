data "aws_memorydb_parameter_group" "this" {
  name   = var.name
  region = var.region
}