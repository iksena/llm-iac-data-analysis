resource "aws_emr_studio_session_mapping" "this" {
  region             = var.region
  identity_id        = var.identity_id
  identity_name      = var.identity_name
  identity_type      = var.identity_type
  session_policy_arn = var.session_policy_arn
  studio_id          = var.studio_id
}