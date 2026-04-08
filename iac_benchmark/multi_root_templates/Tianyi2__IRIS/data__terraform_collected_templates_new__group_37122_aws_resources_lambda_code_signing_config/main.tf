resource "aws_lambda_code_signing_config" "this" {
  description = var.description
  region      = var.region

  allowed_publishers {
    signing_profile_version_arns = var.allowed_publishers_signing_profile_version_arns
  }

  dynamic "policies" {
    for_each = var.policies != null ? [var.policies] : []
    content {
      untrusted_artifact_on_deployment = policies.value.untrusted_artifact_on_deployment
    }
  }

  tags = var.tags
}