resource "aws_guardduty_detector" "this" {
  region                       = var.region
  enable                       = var.enable
  finding_publishing_frequency = var.finding_publishing_frequency
  tags                         = var.tags

  dynamic "datasources" {
    for_each = var.datasources != null ? [var.datasources] : []
    content {
      dynamic "s3_logs" {
        for_each = datasources.value.s3_logs != null ? [datasources.value.s3_logs] : []
        content {
          enable = s3_logs.value.enable
        }
      }

      dynamic "kubernetes" {
        for_each = datasources.value.kubernetes != null ? [datasources.value.kubernetes] : []
        content {
          dynamic "audit_logs" {
            for_each = kubernetes.value.audit_logs != null ? [kubernetes.value.audit_logs] : []
            content {
              enable = audit_logs.value.enable
            }
          }
        }
      }

      dynamic "malware_protection" {
        for_each = datasources.value.malware_protection != null ? [datasources.value.malware_protection] : []
        content {
          dynamic "scan_ec2_instance_with_findings" {
            for_each = malware_protection.value.scan_ec2_instance_with_findings != null ? [malware_protection.value.scan_ec2_instance_with_findings] : []
            content {
              dynamic "ebs_volumes" {
                for_each = scan_ec2_instance_with_findings.value.ebs_volumes != null ? [scan_ec2_instance_with_findings.value.ebs_volumes] : []
                content {
                  enable = ebs_volumes.value.enable
                }
              }
            }
          }
        }
      }
    }
  }
}