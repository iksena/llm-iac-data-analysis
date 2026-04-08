output "function_name" {
  value = aws_lambda_function.lambda.function_name
}

output "function_arn" {
  value = aws_lambda_function.lambda.arn
}

output "lambda_bucket_name" {
  value = "${aws_s3_object.lambda.bucket}/${aws_s3_object.lambda.key}"
}