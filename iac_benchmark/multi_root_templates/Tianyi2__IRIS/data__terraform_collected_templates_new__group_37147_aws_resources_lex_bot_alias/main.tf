resource "aws_lex_bot_alias" "this" {
  region      = var.region
  bot_name    = var.bot_name
  bot_version = var.bot_version
  description = var.description
  name        = var.name

  dynamic "conversation_logs" {
    for_each = var.conversation_logs != null ? [var.conversation_logs] : []
    content {
      iam_role_arn = conversation_logs.value.iam_role_arn

      dynamic "log_settings" {
        for_each = conversation_logs.value.log_settings != null ? conversation_logs.value.log_settings : []
        content {
          destination  = log_settings.value.destination
          kms_key_arn  = log_settings.value.kms_key_arn
          log_type     = log_settings.value.log_type
          resource_arn = log_settings.value.resource_arn
        }
      }
    }
  }

  timeouts {
    create = "1m"
    update = "1m"
    delete = "5m"
  }
}