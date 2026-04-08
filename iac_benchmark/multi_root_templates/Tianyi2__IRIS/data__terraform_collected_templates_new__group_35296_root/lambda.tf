resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "${var.lambda_function_name}"
  retention_in_days = "${var.lambda_logs_retention_in_days}"

  tags {
    environment = "${var.envname}"
    service     = "${var.service}"
  }
}

## create lambda package
data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "${path.module}/include/lambda.py"
  output_path = "${path.cwd}/.terraform/tf-aws-asg-eni-attach-${md5(file("${path.module}/include/lambda.py"))}.zip"
}

## create lambda function
resource "aws_lambda_function" "eni_attach" {
  depends_on       = ["aws_cloudwatch_log_group.lambda_log_group"]
  filename         = ".terraform/tf-aws-asg-eni-attach-${md5(file("${path.module}/include/lambda.py"))}.zip"
  source_code_hash = "${data.archive_file.lambda_package.output_base64sha256}"
  function_name    = "${var.lambda_function_name}"
  role             = "${aws_iam_role.lambda_role.arn}"
  handler          = "lambda.lambda_handler"
  runtime          = "python2.7"
  timeout          = "60"
  publish          = true

  environment = {
    variables = {
      LOG_LEVEL = "${var.lambda_log_level}"
      ENI_TAG   = "${var.eni_tag}"
    }
  }
}
