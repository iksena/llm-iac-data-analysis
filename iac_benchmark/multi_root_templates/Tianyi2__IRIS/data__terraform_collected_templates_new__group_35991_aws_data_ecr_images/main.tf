data "aws_ecr_images" "this" {
  region          = var.region
  registry_id     = var.registry_id
  repository_name = var.repository_name
}