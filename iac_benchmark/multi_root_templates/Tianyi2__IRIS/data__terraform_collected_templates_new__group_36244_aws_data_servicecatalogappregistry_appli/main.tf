data "aws_servicecatalogappregistry_application" "this" {
  id     = var.id
  region = var.region
}