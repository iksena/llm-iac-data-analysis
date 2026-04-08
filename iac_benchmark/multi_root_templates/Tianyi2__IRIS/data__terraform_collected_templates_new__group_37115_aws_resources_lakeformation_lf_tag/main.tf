resource "aws_lakeformation_lf_tag" "this" {
  region     = var.region
  catalog_id = var.catalog_id
  key        = var.key
  values     = var.values
}