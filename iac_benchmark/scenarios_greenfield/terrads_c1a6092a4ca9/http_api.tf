resource "aws_apigatewayv2_api" "api" {
  count         = var.api_type == "http" ? 1 : 0
  name          = var.name
  protocol_type = "HTTP"
  description   = try(var.api_description, "")
}

resource "aws_apigatewayv2_stage" "stage" {
  count       = var.api_type == "http" ? 1 : 0
  api_id      = aws_apigatewayv2_api.api[0].id
  name        = "${var.environment_name}-stage"
  auto_deploy = true
}

resource "aws_apigatewayv2_vpc_link" "gateway_vpc_link" {
  count              = var.api_type == "http" && var.create_vpc_link ? 1 : 0
  name               = "${var.environment_name}-${var.name}-vpclink"
  security_group_ids = []
  subnet_ids         = data.aws_subnets.current.ids
  tags               = var.tags
}

resource "aws_apigatewayv2_integration" "http_integration" {
  for_each           = { for integration in var.routes : integration.name => integration if var.api_type == "http" }
  api_id             = aws_apigatewayv2_api.api[0].id
  integration_type   = each.value.integration_type
  integration_method = each.value.integration_method
  integration_uri    = each.value.integration_uri
}
resource "aws_apigatewayv2_route" "integration_route" {
  for_each  = { for integration in var.routes : integration.name => integration if var.api_type == "http" }
  api_id    = aws_apigatewayv2_api.api[0].id
  route_key = "ANY /${each.value.api_route_mapping}"

  target = "integrations/${aws_apigatewayv2_integration.http_integration[each.value.name].id}"
}

