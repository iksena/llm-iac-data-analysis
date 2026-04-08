resource "aws_dynamodb_resource_policy" "this" {
  resource_arn                        = var.resource_arn
  policy                              = var.policy
  region                              = var.region
  confirm_remove_self_resource_access = var.confirm_remove_self_resource_access
}