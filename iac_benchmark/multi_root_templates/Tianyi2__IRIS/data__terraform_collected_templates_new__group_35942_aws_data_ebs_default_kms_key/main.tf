data "aws_ebs_default_kms_key" "this" {
  region = var.region

  timeouts {
    read = var.read_timeout
  }
}