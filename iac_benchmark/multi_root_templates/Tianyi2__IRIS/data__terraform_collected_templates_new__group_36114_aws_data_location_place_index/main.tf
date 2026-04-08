data "aws_location_place_index" "this" {
  region     = var.region
  index_name = var.index_name
}