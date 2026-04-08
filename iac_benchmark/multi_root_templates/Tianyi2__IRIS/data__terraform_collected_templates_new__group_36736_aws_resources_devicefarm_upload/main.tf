resource "aws_devicefarm_upload" "this" {
  region       = var.region
  content_type = var.content_type
  name         = var.name
  project_arn  = var.project_arn
  type         = var.type
}