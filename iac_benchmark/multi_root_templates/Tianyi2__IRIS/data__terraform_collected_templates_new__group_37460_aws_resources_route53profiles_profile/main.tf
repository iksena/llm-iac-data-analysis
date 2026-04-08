resource "aws_route53profiles_profile" "this" {
  region = var.region
  name   = var.name
  tags   = var.tags

  timeouts {
    create = var.timeouts_create
    read   = var.timeouts_read
    delete = var.timeouts_delete
  }
}