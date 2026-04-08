data "aws_ebs_encryption_by_default" "this" {
  region = var.region

  timeouts {
    read = var.timeouts.read
  }
}