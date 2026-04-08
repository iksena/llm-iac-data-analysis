resource "aws_inspector2_enabler" "this" {
  region         = var.region
  account_ids    = var.account_ids
  resource_types = var.resource_types

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}