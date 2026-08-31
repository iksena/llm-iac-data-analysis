resource "aws_api_gateway_usage_plan" "usage_plan" {
  count = var.create_api_key && var.api_type == "rest" ? 1 : 0
  name  = "${var.environment_name}-${var.name}-usage-plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.rest_api[0].id
    stage  = aws_api_gateway_stage.rest_stage[0].stage_name
  }
}

resource "aws_api_gateway_api_key" "api_key" {
  count   = var.create_api_key && var.api_type == "rest" ? 1 : 0
  name    = "${var.environment_name}-${var.name}-api-key"
  enabled = true
}

resource "aws_ssm_parameter" "gateway_api_key" {
  count = var.create_api_key && var.api_type == "rest" ? 1 : 0
  name  = "/${var.environment_name}/${var.name}/api_key"
  type  = "SecureString"
  value = aws_api_gateway_api_key.api_key[0].value
}

resource "aws_api_gateway_usage_plan_key" "api_usage_plan" {
  count         = var.create_api_key && var.api_type == "rest" ? 1 : 0
  key_id        = aws_api_gateway_api_key.api_key[0].id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.usage_plan[0].id
}