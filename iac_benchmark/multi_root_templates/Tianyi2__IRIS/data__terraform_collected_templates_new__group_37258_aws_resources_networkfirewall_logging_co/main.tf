resource "aws_networkfirewall_logging_configuration" "this" {
  region       = var.region
  firewall_arn = var.firewall_arn

  logging_configuration {
    dynamic "log_destination_config" {
      for_each = var.logging_configuration.log_destination_config
      content {
        log_destination      = log_destination_config.value.log_destination
        log_destination_type = log_destination_config.value.log_destination_type
        log_type             = log_destination_config.value.log_type
      }
    }
  }
}