resource "aws_resiliencehub_resiliency_policy" "this" {
  name                     = var.name
  tier                     = var.tier
  description              = var.description
  data_location_constraint = var.data_location_constraint
  tags                     = var.tags

  policy {
    dynamic "region" {
      for_each = var.policy.region != null ? [var.policy.region] : []
      content {
        rpo = region.value.rpo
        rto = region.value.rto
      }
    }

    az {
      rpo = var.policy.az.rpo
      rto = var.policy.az.rto
    }

    hardware {
      rpo = var.policy.hardware.rpo
      rto = var.policy.hardware.rto
    }

    software {
      rpo = var.policy.software.rpo
      rto = var.policy.software.rto
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}