resource "aws_verifiedpermissions_policy" "this" {
  region          = var.region
  policy_store_id = var.policy_store_id

  definition {
    dynamic "static" {
      for_each = var.definition_static != null ? [var.definition_static] : []
      content {
        description = static.value.description
        statement   = static.value.statement
      }
    }

    dynamic "template_linked" {
      for_each = var.definition_template_linked != null ? [var.definition_template_linked] : []
      content {
        policy_template_id = template_linked.value.policy_template_id

        dynamic "principal" {
          for_each = template_linked.value.principal != null ? [template_linked.value.principal] : []
          content {
            entity_id   = principal.value.entity_id
            entity_type = principal.value.entity_type
          }
        }

        dynamic "resource" {
          for_each = template_linked.value.resource != null ? [template_linked.value.resource] : []
          content {
            entity_id   = resource.value.entity_id
            entity_type = resource.value.entity_type
          }
        }
      }
    }
  }
}