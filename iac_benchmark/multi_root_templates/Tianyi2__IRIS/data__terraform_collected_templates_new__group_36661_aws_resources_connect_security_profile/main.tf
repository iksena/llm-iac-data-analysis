resource "aws_connect_security_profile" "this" {
  instance_id = var.instance_id
  name        = var.name
  description = var.description
  permissions = var.permissions
  tags        = var.tags
}