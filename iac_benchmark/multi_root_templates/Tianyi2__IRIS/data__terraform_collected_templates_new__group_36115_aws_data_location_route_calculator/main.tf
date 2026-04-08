data "aws_location_route_calculator" "this" {
  calculator_name = var.calculator_name
  region          = var.region
}