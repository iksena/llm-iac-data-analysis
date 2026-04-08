resource "aws_iot_policy" "this" {
  region = var.region
  name   = var.name
  policy = var.policy
  tags   = var.tags

  timeouts {
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
}