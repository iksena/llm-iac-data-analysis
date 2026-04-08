resource "aws_connect_lambda_function_association" "this" {
  region       = var.region
  function_arn = var.function_arn
  instance_id  = var.instance_id
}