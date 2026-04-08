resource "aws_elastic_beanstalk_application_version" "this" {
  application  = var.application
  bucket       = var.bucket
  key          = var.key
  name         = var.name
  region       = var.region
  description  = var.description
  force_delete = var.force_delete
  process      = var.process
  tags         = var.tags
}