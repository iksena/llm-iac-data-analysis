resource "aws_lambda_event_source_mapping" "lambda1_kinesis_trigger" {
  event_source_arn  = aws_kinesis_stream.data_stream.arn
  function_name     = aws_lambda_function.lambda_one.arn
  starting_position = "LATEST"
}

resource "aws_lambda_event_source_mapping" "lambda2_dynamodb_trigger" {
  event_source_arn  = aws_dynamodb_table.table_one.stream_arn
  function_name     = aws_lambda_function.lambda_two.arn
  starting_position = "LATEST"
}