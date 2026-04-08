resource "aws_route53profiles_resource_association" "this" {
  region              = var.region
  name                = var.name
  profile_id          = var.profile_id
  resource_arn        = var.resource_arn
  resource_properties = var.resource_properties

  timeouts {
    create = var.timeouts_create
    delete = var.timeouts_delete
  }
}