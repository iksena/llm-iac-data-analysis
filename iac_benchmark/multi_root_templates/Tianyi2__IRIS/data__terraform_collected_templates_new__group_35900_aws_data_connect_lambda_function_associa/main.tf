data "aws_connect_lambda_function_association" "this" {
  function_arn = var.function_arn
  instance_id  = var.instance_id
  region       = var.region
}