resource "aws_glue_resource_policy" "this" {
  policy        = var.policy
  region        = var.region
  enable_hybrid = var.enable_hybrid
}