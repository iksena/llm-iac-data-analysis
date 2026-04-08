data "aws_ecr_repository" "this" {
  name        = var.name
  registry_id = var.registry_id
  region      = var.region
}