resource "aws_securitylake_custom_log_source" "this" {
  region         = var.region
  source_name    = var.source_name
  source_version = var.source_version
  event_classes  = var.event_classes

  configuration {
    crawler_configuration {
      role_arn = var.crawler_configuration_role_arn
    }

    provider_identity {
      external_id = var.provider_identity_external_id
      principal   = var.provider_identity_principal
    }
  }
}