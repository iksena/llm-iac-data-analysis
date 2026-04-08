resource "aws_lambda_function" "lambda_one" {
  filename         = "../src/${var.lambda_function_one_name}.zip"  
  function_name    = var.lambda_function_one_name
  handler          = var.lambda_one_handler
  runtime          = var.lambda_one_runtime
  role             = var.lambda_role_arn
}

resource "aws_lambda_function" "lambda_two" {
  filename         = "../src/${var.lambda_function_two_name}.zip"
  function_name    = var.lambda_function_two_name
  handler          = var.lambda_two_handler
  runtime          = var.lambda_two_runtime
  role             = var.lambda_role_arn
}
