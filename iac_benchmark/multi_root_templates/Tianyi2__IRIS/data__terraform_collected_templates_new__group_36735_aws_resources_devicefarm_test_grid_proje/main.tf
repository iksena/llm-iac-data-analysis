resource "aws_devicefarm_test_grid_project" "this" {
  region      = var.region
  name        = var.name
  description = var.description
  tags        = var.tags

  vpc_config {
    vpc_id             = var.vpc_config.vpc_id
    subnet_ids         = var.vpc_config.subnet_ids
    security_group_ids = var.vpc_config.security_group_ids
  }
}