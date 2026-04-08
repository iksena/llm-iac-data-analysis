resource "aws_prometheus_scraper" "this" {
  region               = var.region
  alias                = var.alias
  scrape_configuration = var.scrape_configuration

  destination {
    amp {
      workspace_arn = var.destination_amp_workspace_arn
    }
  }

  source {
    eks {
      cluster_arn        = var.source_eks_cluster_arn
      subnet_ids         = var.source_eks_subnet_ids
      security_group_ids = var.source_eks_security_group_ids
    }
  }

  dynamic "role_configuration" {
    for_each = var.role_configuration != null ? [var.role_configuration] : []
    content {
      source_role_arn = role_configuration.value.source_role_arn
      target_role_arn = role_configuration.value.target_role_arn
    }
  }

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
}