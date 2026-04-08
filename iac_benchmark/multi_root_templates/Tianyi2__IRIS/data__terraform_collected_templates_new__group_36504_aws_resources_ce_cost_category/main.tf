resource "aws_ce_cost_category" "this" {
  name            = var.name
  rule_version    = var.rule_version
  default_value   = var.default_value
  effective_start = var.effective_start
  tags            = var.tags

  dynamic "rule" {
    for_each = var.rules
    content {
      value = rule.value.value
      type  = rule.value.type

      dynamic "inherited_value" {
        for_each = rule.value.inherited_value != null ? [rule.value.inherited_value] : []
        content {
          dimension_key  = inherited_value.value.dimension_key
          dimension_name = inherited_value.value.dimension_name
        }
      }

      dynamic "rule" {
        for_each = rule.value.rule != null ? [rule.value.rule] : []
        content {
          dynamic "and" {
            for_each = rule.value.rule.and != null ? rule.value.rule.and : []
            content {
              dynamic "cost_category" {
                for_each = and.value.cost_category != null ? [and.value.cost_category] : []
                content {
                  key           = cost_category.value.key
                  values        = cost_category.value.values
                  match_options = cost_category.value.match_options
                }
              }

              dynamic "dimension" {
                for_each = and.value.dimension != null ? [and.value.dimension] : []
                content {
                  key           = dimension.value.key
                  values        = dimension.value.values
                  match_options = dimension.value.match_options
                }
              }

              dynamic "tags" {
                for_each = and.value.tags != null ? [and.value.tags] : []
                content {
                  key           = tags.value.key
                  values        = tags.value.values
                  match_options = tags.value.match_options
                }
              }
            }
          }

          dynamic "or" {
            for_each = rule.value.rule.or != null ? rule.value.rule.or : []
            content {
              dynamic "cost_category" {
                for_each = or.value.cost_category != null ? [or.value.cost_category] : []
                content {
                  key           = cost_category.value.key
                  values        = cost_category.value.values
                  match_options = cost_category.value.match_options
                }
              }

              dynamic "dimension" {
                for_each = or.value.dimension != null ? [or.value.dimension] : []
                content {
                  key           = dimension.value.key
                  values        = dimension.value.values
                  match_options = dimension.value.match_options
                }
              }

              dynamic "tags" {
                for_each = or.value.tags != null ? [or.value.tags] : []
                content {
                  key           = tags.value.key
                  values        = tags.value.values
                  match_options = tags.value.match_options
                }
              }
            }
          }

          dynamic "not" {
            for_each = rule.value.rule.not != null ? [rule.value.rule.not] : []
            content {
              dynamic "cost_category" {
                for_each = not.value.cost_category != null ? [not.value.cost_category] : []
                content {
                  key           = cost_category.value.key
                  values        = cost_category.value.values
                  match_options = cost_category.value.match_options
                }
              }

              dynamic "dimension" {
                for_each = not.value.dimension != null ? [not.value.dimension] : []
                content {
                  key           = dimension.value.key
                  values        = dimension.value.values
                  match_options = dimension.value.match_options
                }
              }

              dynamic "tags" {
                for_each = not.value.tags != null ? [not.value.tags] : []
                content {
                  key           = tags.value.key
                  values        = tags.value.values
                  match_options = tags.value.match_options
                }
              }
            }
          }

          dynamic "cost_category" {
            for_each = rule.value.rule.cost_category != null ? [rule.value.rule.cost_category] : []
            content {
              key           = cost_category.value.key
              values        = cost_category.value.values
              match_options = cost_category.value.match_options
            }
          }

          dynamic "dimension" {
            for_each = rule.value.rule.dimension != null ? [rule.value.rule.dimension] : []
            content {
              key           = dimension.value.key
              values        = dimension.value.values
              match_options = dimension.value.match_options
            }
          }

          dynamic "tags" {
            for_each = rule.value.rule.tags != null ? [rule.value.rule.tags] : []
            content {
              key           = tags.value.key
              values        = tags.value.values
              match_options = tags.value.match_options
            }
          }
        }
      }
    }
  }

  dynamic "split_charge_rule" {
    for_each = var.split_charge_rules != null ? var.split_charge_rules : []
    content {
      method  = split_charge_rule.value.method
      source  = split_charge_rule.value.source
      targets = split_charge_rule.value.targets

      dynamic "parameter" {
        for_each = split_charge_rule.value.parameter != null ? [split_charge_rule.value.parameter] : []
        content {
          type   = parameter.value.type
          values = parameter.value.values
        }
      }
    }
  }
}