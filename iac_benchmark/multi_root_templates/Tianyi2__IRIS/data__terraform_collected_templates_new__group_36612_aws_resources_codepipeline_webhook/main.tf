resource "aws_codepipeline_webhook" "this" {
  region          = var.region
  name            = var.name
  authentication  = var.authentication
  target_action   = var.target_action
  target_pipeline = var.target_pipeline
  tags            = var.tags

  dynamic "authentication_configuration" {
    for_each = var.authentication_configuration != null ? [var.authentication_configuration] : []
    content {
      secret_token     = authentication_configuration.value.secret_token
      allowed_ip_range = authentication_configuration.value.allowed_ip_range
    }
  }

  dynamic "filter" {
    for_each = var.filter
    content {
      json_path    = filter.value.json_path
      match_equals = filter.value.match_equals
    }
  }
}