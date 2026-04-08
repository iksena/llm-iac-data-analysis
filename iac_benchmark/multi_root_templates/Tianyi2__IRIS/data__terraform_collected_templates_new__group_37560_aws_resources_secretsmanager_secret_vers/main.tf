locals {
  # Ensure exactly one of secret_string, secret_binary, or secret_string_wo is set
  secret_inputs_count = length(compact([
    var.secret_string,
    var.secret_binary,
    var.secret_string_wo
  ]))

  # Validation: exactly one secret input must be provided
  validate_secret_inputs = local.secret_inputs_count == 1 ? true : tobool("Exactly one of secret_string, secret_binary, or secret_string_wo must be set")
}

resource "aws_secretsmanager_secret_version" "this" {
  region                   = var.region
  secret_id                = var.secret_id
  secret_string            = var.secret_string
  secret_string_wo         = var.secret_string_wo
  secret_string_wo_version = var.secret_string_wo_version
  secret_binary            = var.secret_binary
  version_stages           = var.version_stages

  # Force validation
  lifecycle {
    precondition {
      condition     = local.validate_secret_inputs
      error_message = "Exactly one of secret_string, secret_binary, or secret_string_wo must be set."
    }
  }
}