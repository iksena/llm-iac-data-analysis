data "aws_ecr_image" "this" {
  region          = var.region
  registry_id     = var.registry_id
  repository_name = var.repository_name
  image_digest    = var.image_digest
  image_tag       = var.image_tag
  most_recent     = var.most_recent
}