resource "aws_ec2_default_credit_specification" "this" {
  region          = var.region
  cpu_credits     = var.cpu_credits
  instance_family = var.instance_family

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
  }
}