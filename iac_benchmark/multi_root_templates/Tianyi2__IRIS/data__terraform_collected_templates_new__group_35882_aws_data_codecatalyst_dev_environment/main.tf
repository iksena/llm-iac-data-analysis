data "aws_codecatalyst_dev_environment" "this" {
  region       = var.region
  env_id       = var.env_id
  project_name = var.project_name
  space_name   = var.space_name
}