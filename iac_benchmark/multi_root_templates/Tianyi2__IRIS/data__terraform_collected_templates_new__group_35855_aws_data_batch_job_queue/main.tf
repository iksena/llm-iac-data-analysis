data "aws_batch_job_queue" "this" {
  name   = var.name
  region = var.region
}