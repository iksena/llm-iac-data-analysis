resource "aws_devicefarm_project" "this" {
  region                      = var.region
  name                        = var.name
  default_job_timeout_minutes = var.default_job_timeout_minutes
  tags                        = var.tags
}