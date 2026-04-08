data "aws_dx_location" "this" {
  region        = var.region
  location_code = var.location_code
}