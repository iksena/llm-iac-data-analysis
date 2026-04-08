data "aws_redshiftserverless_namespace" "this" {
  namespace_name = var.namespace_name
  region         = var.region
}