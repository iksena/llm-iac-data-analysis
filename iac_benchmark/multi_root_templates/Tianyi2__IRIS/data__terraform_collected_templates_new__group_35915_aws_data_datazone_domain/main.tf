locals {
  validation_check = var.name != null || var.id != null ? true : tobool("One of 'name' or 'id' is required for data_aws_datazone_domain")
}

data "aws_datazone_domain" "this" {
  region = var.region
  name   = var.name
  id     = var.id
}