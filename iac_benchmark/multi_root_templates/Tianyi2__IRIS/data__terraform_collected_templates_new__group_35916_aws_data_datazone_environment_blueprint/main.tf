data "aws_datazone_environment_blueprint" "this" {
  region    = var.region
  domain_id = var.domain_id
  name      = var.name
  managed   = var.managed
}