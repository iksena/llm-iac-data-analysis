resource "aws_sagemaker_workteam" "this" {
  region         = var.region
  description    = var.description
  workforce_name = var.workforce_name
  workteam_name  = var.workteam_name

  dynamic "member_definition" {
    for_each = var.member_definition
    content {
      dynamic "cognito_member_definition" {
        for_each = member_definition.value.cognito_member_definition != null ? [member_definition.value.cognito_member_definition] : []
        content {
          client_id  = cognito_member_definition.value.client_id
          user_pool  = cognito_member_definition.value.user_pool
          user_group = cognito_member_definition.value.user_group
        }
      }

      dynamic "oidc_member_definition" {
        for_each = member_definition.value.oidc_member_definition != null ? [member_definition.value.oidc_member_definition] : []
        content {
          groups = oidc_member_definition.value.groups
        }
      }
    }
  }

  dynamic "notification_configuration" {
    for_each = var.notification_configuration != null ? [var.notification_configuration] : []
    content {
      notification_topic_arn = notification_configuration.value.notification_topic_arn
    }
  }

  dynamic "worker_access_configuration" {
    for_each = var.worker_access_configuration != null ? [var.worker_access_configuration] : []
    content {
      s3_presign {
        iam_policy_constraints {
          source_ip     = worker_access_configuration.value.s3_presign.iam_policy_constraints.source_ip
          vpc_source_ip = worker_access_configuration.value.s3_presign.iam_policy_constraints.vpc_source_ip
        }
      }
    }
  }

  tags = var.tags
}