check "exactly_one_specified" {
  assert {
    condition     = var.name != null || var.resource_arn != null
    error_message = "data_aws_wafv2_web_acl: exactly one of name or resource_arn must be specified."
  }
}

check "only_one_specified" {
  assert {
    condition     = !(var.name != null && var.resource_arn != null)
    error_message = "data_aws_wafv2_web_acl: exactly one of name or resource_arn must be specified, not both."
  }
}

data "aws_wafv2_web_acl" "this" {
  name         = var.name
  region       = var.region
  resource_arn = var.resource_arn
  scope        = var.scope
}