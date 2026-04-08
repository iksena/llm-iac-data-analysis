data "aws_mskconnect_worker_configuration" "this" {
  name   = var.name
  region = var.region
}