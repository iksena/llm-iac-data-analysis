resource "aws_imagebuilder_lifecycle_policy" "this" {
  name           = var.name
  resource_type  = var.resource_type
  execution_role = var.execution_role
  region         = var.region
  description    = var.description
  tags           = var.tags

  policy_detail {

    action {
      type = var.policy_detail.action.type
      include_resources {
        amis       = var.policy_detail.action.include_resources.amis
        containers = var.policy_detail.action.include_resources.containers
        snapshots  = var.policy_detail.action.include_resources.snapshots
      }
    }

    filter {
      type            = var.policy_detail.filter.type
      value           = var.policy_detail.filter.value
      retain_at_least = var.policy_detail.filter.retain_at_least
      unit            = var.policy_detail.filter.unit
    }

    dynamic "exclusion_rules" {
      for_each = var.policy_detail.exclusion_rules != null ? [var.policy_detail.exclusion_rules] : []
      content {
        tag_map = exclusion_rules.value.tag_map

        dynamic "amis" {
          for_each = exclusion_rules.value.amis != null ? [exclusion_rules.value.amis] : []
          content {
            is_public       = amis.value.is_public
            regions         = amis.value.regions
            shared_accounts = amis.value.shared_accounts
            tag_map         = amis.value.tag_map

            dynamic "last_launched" {
              for_each = amis.value.last_launched != null ? [amis.value.last_launched] : []
              content {
                unit  = last_launched.value.unit
                value = last_launched.value.value
              }
            }
          }
        }
      }
    }
  }

  resource_selection {
    tag_map = var.resource_selection.tag_map

    dynamic "recipe" {
      for_each = var.resource_selection.recipe != null ? var.resource_selection.recipe : []
      content {
        name             = recipe.value.name
        semantic_version = recipe.value.semantic_version
      }
    }
  }
}