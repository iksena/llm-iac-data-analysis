resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/apigateway/${local.apigateway_name}"
  retention_in_days = 14

}
