locals {
  # Validate that content and filename are mutually exclusive
  validate_content_filename = var.content != null && var.filename != null ? tobool("content and filename cannot both be specified") : true
}

resource "aws_connect_contact_flow" "this" {
  instance_id  = var.instance_id
  name         = var.name
  content      = var.content
  content_hash = var.content_hash
  description  = var.description
  filename     = var.filename
  region       = var.region
  tags         = var.tags
  type         = var.type
}