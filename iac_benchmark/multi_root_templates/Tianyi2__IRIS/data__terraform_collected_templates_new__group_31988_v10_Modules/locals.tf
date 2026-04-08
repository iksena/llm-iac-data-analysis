locals {
  location_prefix     = replace(var.resource_location, "/[a-z[:space:]]/", "")
  resource_group_name = "${var.resource_group_name}-${replace(var.resource_location, "/[a-z[:space:]]/", "")}"
  resource_name       = "${var.resource_name}-${local.location_prefix}"
}