# S3 Bucket
output "bucket_name" {
  description = "S3: Bucket details"
  value = aws_s3_bucket.my_bucket.id
}

output "kinesis_stream" {
  description = "Kinesis: Stream details"
  value = {
    name = aws_kinesis_stream.data_stream.name
    arn  = aws_kinesis_stream.data_stream.arn
  }
}

output "dynamodb_tables" {
  description = "DynamoDB: Tables and Stream ARN"
  value = {
    table_one_name = aws_dynamodb_table.table_one.name
    table_one_stream_arn = aws_dynamodb_table.table_one.stream_arn
    table_two_name = aws_dynamodb_table.table_two.name
  }
}

output "lambda_functions" {
  description = "Lambda: Function names"
  value = {
    ingest_lambda  = aws_lambda_function.lambda_one.function_name
    process_lambda = aws_lambda_function.lambda_two.function_name
  }
}

output "glue_resources" {
  description = "Glue: Crawler and database"
  value = {
    crawler_name  = aws_glue_crawler.my_crawler.name
    database_name = aws_glue_catalog_database.my_database.name
  }
}