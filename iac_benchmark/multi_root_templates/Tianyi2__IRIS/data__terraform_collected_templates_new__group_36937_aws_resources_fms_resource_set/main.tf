resource "aws_fms_resource_set" "this" {
  region = var.region

  resource_set {
    name                = var.resource_set.name
    resource_type_list  = var.resource_set.resource_type_list
    description         = var.resource_set.description
    resource_set_status = var.resource_set.resource_set_status
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}