resource "aws_ebs_encryption_by_default" "this" {
  region  = var.region
  enabled = var.enabled
}