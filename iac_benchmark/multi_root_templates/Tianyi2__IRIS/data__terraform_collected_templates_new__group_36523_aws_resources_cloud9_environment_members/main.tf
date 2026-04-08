resource "aws_cloud9_environment_membership" "this" {
  region         = var.region
  environment_id = var.environment_id
  permissions    = var.permissions
  user_arn       = var.user_arn
}