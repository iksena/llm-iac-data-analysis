resource "aws_connect_vocabulary" "this" {
  instance_id   = var.instance_id
  name          = var.name
  content       = var.content
  language_code = var.language_code
  tags          = var.tags

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}