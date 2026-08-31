output "start_lambda" {
  value = "https://${data.aws_region.current.name}.console.aws.amazon.com/lambda/home?region=${data.aws_region.current.name}#/functions/${aws_lambda_function.start_ecs_service.function_name}?tab=code"
}

output "stop_lambda" {
  value = "https://${data.aws_region.current.name}.console.aws.amazon.com/lambda/home?region=${data.aws_region.current.name}#/functions/${aws_lambda_function.stop_ecs_service.function_name}?tab=code"
}

output "start_eventbridge_rule" {
  value = "https://${data.aws_region.current.name}.console.aws.amazon.com/events/home?region=${data.aws_region.current.name}#/eventbus/default/rules/${aws_cloudwatch_event_rule.start_lambda.name}"
}

output "stop_eventbridge_rule" {
  value = "https://${data.aws_region.current.name}.console.aws.amazon.com/events/home?region=${data.aws_region.current.name}#/eventbus/default/rules/${aws_cloudwatch_event_rule.stop_lambda.name}"
}

output "s3" {
  value = "https://${data.aws_region.current.name}.console.aws.amazon.com/s3/buckets/${aws_s3_bucket.ecs_services_scheduler.bucket}?bucketType=general&region=${data.aws_region.current.name}&tab=objects"
}
