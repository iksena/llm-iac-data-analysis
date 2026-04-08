resource "aws_location_route_calculator" "this" {
  calculator_name = var.calculator_name
  data_source     = var.data_source
  region          = var.region
  description     = var.description
  tags            = var.tags

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}