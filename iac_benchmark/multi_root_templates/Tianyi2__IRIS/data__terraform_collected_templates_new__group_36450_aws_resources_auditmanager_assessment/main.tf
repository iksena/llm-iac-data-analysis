resource "aws_auditmanager_assessment" "this" {
  name         = var.name
  description  = var.description
  framework_id = var.framework_id
  region       = var.region
  tags         = var.tags

  assessment_reports_destination {
    destination      = var.assessment_reports_destination.destination
    destination_type = var.assessment_reports_destination.destination_type
  }

  dynamic "roles" {
    for_each = var.roles
    content {
      role_arn  = roles.value.role_arn
      role_type = roles.value.role_type
    }
  }

  scope {
    dynamic "aws_accounts" {
      for_each = var.scope.aws_accounts != null ? var.scope.aws_accounts : []
      content {
        id = aws_accounts.value.id
      }
    }

    dynamic "aws_services" {
      for_each = var.scope.aws_services != null ? var.scope.aws_services : []
      content {
        service_name = aws_services.value.service_name
      }
    }
  }
}