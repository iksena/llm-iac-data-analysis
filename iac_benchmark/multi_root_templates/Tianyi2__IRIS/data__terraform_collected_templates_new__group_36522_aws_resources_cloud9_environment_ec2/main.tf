resource "aws_cloud9_environment_ec2" "this" {
  name                        = var.name
  instance_type               = var.instance_type
  image_id                    = var.image_id
  automatic_stop_time_minutes = var.automatic_stop_time_minutes
  connection_type             = var.connection_type
  description                 = var.description
  owner_arn                   = var.owner_arn
  subnet_id                   = var.subnet_id
  tags                        = var.tags
}