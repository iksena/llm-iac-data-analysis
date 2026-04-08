resource "aws_schemas_registry_policy" "this" {
  registry_name = var.registry_name
  policy        = var.policy
  region        = var.region
}