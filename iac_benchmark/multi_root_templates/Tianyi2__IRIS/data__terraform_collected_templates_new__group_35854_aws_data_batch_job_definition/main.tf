data "aws_batch_job_definition" "this" {
  region   = var.region
  arn      = var.arn
  revision = var.revision
  name     = var.name
  status   = var.status
}