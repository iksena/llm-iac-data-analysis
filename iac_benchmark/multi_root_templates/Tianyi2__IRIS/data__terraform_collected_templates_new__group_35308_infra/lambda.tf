resource "aws_iam_policy" "dynamodb_access_policy" {
  name = "playbooks-api_lambda_access_dynamodb_policy"
  path = "/"

  policy = templatefile("templates/dynamo_access_policy.json", { table = aws_dynamodb_table.playbook_versions.name })
}

module "playbooks_lambda" {
  source      = "git@github.com:moggiez/terraform-modules.git//lambda_with_dynamo"
  s3_bucket   = aws_s3_bucket._
  dist_dir    = "../dist"
  name        = "playbooks-api"
  policies    = [aws_iam_policy.dynamodb_access_policy.arn]
  environment = local.environment
}

resource "aws_lambda_permission" "_" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.playbooks_lambda.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api._.execution_arn}/*/*"
}