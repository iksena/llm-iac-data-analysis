resource "aws_route53profiles_association" "this" {
  region      = var.region
  name        = var.name
  profile_id  = var.profile_id
  resource_id = var.resource_id
  tags        = var.tags

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}