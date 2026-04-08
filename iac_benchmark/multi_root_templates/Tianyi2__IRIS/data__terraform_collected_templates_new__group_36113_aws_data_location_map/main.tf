data "aws_location_map" "this" {
  region   = var.region
  map_name = var.map_name
}