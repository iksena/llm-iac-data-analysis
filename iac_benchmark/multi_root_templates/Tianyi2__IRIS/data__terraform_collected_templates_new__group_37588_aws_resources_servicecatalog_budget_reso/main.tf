resource "aws_servicecatalog_budget_resource_association" "this" {
  budget_name = var.budget_name
  resource_id = var.resource_id
  region      = var.region

  timeouts {
    create = var.timeouts.create
    read   = var.timeouts.read
    delete = var.timeouts.delete
  }
}