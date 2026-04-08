resource "aws_location_map" "this" {
  map_name = var.map_name

  configuration {
    style = var.configuration.style
  }

  region      = var.region
  description = var.description
  tags        = var.tags
}