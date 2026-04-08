resource "aws_securitylake_subscriber_notification" "this" {
  region        = var.region
  subscriber_id = var.subscriber_id

  configuration {
    dynamic "sqs_notification_configuration" {
      for_each = var.sqs_notification_configuration != null ? [var.sqs_notification_configuration] : []
      content {}
    }

    dynamic "https_notification_configuration" {
      for_each = var.https_notification_configuration != null ? [var.https_notification_configuration] : []
      content {
        endpoint                    = https_notification_configuration.value.endpoint
        target_role_arn             = https_notification_configuration.value.target_role_arn
        authorization_api_key_name  = https_notification_configuration.value.authorization_api_key_name
        authorization_api_key_value = https_notification_configuration.value.authorization_api_key_value
        http_method                 = https_notification_configuration.value.http_method
      }
    }
  }
}