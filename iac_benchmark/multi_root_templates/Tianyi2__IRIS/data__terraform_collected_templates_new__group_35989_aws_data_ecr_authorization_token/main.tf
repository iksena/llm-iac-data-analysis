data "aws_ecr_authorization_token" "this" {
  region      = var.region
  registry_id = var.registry_id
}