data "aws_batch_compute_environment" "this" {
  region = var.region
  name   = var.name
}