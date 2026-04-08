resource "aws_connect_contact_flow_module" "this" {
  instance_id  = var.instance_id
  name         = var.name
  description  = var.description
  content      = var.content
  content_hash = var.content_hash
  filename     = var.filename
  tags         = var.tags
}