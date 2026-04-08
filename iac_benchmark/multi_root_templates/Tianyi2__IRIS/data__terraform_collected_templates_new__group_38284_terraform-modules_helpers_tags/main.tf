locals {
  common_tags = {
    "Project"     = var.project
    "Client"      = var.client
    "Owner"       = var.owner
    "Terraform"   = true
    "Environment" = var.environment
  }

  all_tags = merge(local.common_tags, var.additional_tags)
}