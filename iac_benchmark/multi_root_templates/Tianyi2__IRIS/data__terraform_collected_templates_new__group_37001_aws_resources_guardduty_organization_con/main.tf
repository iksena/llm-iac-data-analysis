resource "aws_guardduty_organization_configuration" "this" {
  region                           = var.region
  auto_enable_organization_members = var.auto_enable_organization_members
  detector_id                      = var.detector_id

  dynamic "datasources" {
    for_each = var.datasources != null ? [var.datasources] : []
    content {
      dynamic "s3_logs" {
        for_each = datasources.value.s3_logs != null ? [datasources.value.s3_logs] : []
        content {
          auto_enable = s3_logs.value.auto_enable
        }
      }

      dynamic "kubernetes" {
        for_each = datasources.value.kubernetes != null ? [datasources.value.kubernetes] : []
        content {
          audit_logs {
            enable = kubernetes.value.audit_logs.enable
          }
        }
      }

      dynamic "malware_protection" {
        for_each = datasources.value.malware_protection != null ? [datasources.value.malware_protection] : []
        content {
          scan_ec2_instance_with_findings {
            ebs_volumes {
              auto_enable = malware_protection.value.scan_ec2_instance_with_findings.ebs_volumes.auto_enable
            }
          }
        }
      }
    }
  }
}