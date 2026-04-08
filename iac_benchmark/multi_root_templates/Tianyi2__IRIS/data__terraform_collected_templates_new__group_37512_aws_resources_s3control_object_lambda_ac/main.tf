resource "aws_s3control_object_lambda_access_point" "this" {
  region     = var.region
  account_id = var.account_id
  name       = var.name

  configuration {
    allowed_features            = var.allowed_features
    cloud_watch_metrics_enabled = var.cloud_watch_metrics_enabled
    supporting_access_point     = var.supporting_access_point

    dynamic "transformation_configuration" {
      for_each = var.transformation_configurations
      content {
        actions = transformation_configuration.value.actions

        content_transformation {
          aws_lambda {
            function_arn     = transformation_configuration.value.aws_lambda.function_arn
            function_payload = transformation_configuration.value.aws_lambda.function_payload
          }
        }
      }
    }
  }
}