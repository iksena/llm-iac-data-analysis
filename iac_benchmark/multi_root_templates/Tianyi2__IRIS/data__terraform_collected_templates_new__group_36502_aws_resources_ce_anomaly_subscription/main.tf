resource "aws_ce_anomaly_subscription" "this" {
  account_id       = var.account_id
  frequency        = var.frequency
  monitor_arn_list = var.monitor_arn_list
  name             = var.name
  tags             = var.tags

  dynamic "subscriber" {
    for_each = var.subscriber
    content {
      type    = subscriber.value.type
      address = subscriber.value.address
    }
  }

  dynamic "threshold_expression" {
    for_each = var.threshold_expression != null ? [var.threshold_expression] : []
    content {
      dynamic "and" {
        for_each = threshold_expression.value.and != null ? threshold_expression.value.and : []
        content {
          dynamic "cost_category" {
            for_each = and.value.cost_category != null ? [and.value.cost_category] : []
            content {
              key           = cost_category.value.key
              match_options = cost_category.value.match_options
              values        = cost_category.value.values
            }
          }

          dynamic "dimension" {
            for_each = and.value.dimension != null ? [and.value.dimension] : []
            content {
              key           = dimension.value.key
              match_options = dimension.value.match_options
              values        = dimension.value.values
            }
          }

          dynamic "tags" {
            for_each = and.value.tags != null ? [and.value.tags] : []
            content {
              key           = tags.value.key
              match_options = tags.value.match_options
              values        = tags.value.values
            }
          }
        }
      }

      dynamic "cost_category" {
        for_each = threshold_expression.value.cost_category != null ? [threshold_expression.value.cost_category] : []
        content {
          key           = cost_category.value.key
          match_options = cost_category.value.match_options
          values        = cost_category.value.values
        }
      }

      dynamic "dimension" {
        for_each = threshold_expression.value.dimension != null ? [threshold_expression.value.dimension] : []
        content {
          key           = dimension.value.key
          match_options = dimension.value.match_options
          values        = dimension.value.values
        }
      }

      dynamic "not" {
        for_each = threshold_expression.value.not != null ? threshold_expression.value.not : []
        content {
          dynamic "cost_category" {
            for_each = not.value.cost_category != null ? [not.value.cost_category] : []
            content {
              key           = cost_category.value.key
              match_options = cost_category.value.match_options
              values        = cost_category.value.values
            }
          }

          dynamic "dimension" {
            for_each = not.value.dimension != null ? [not.value.dimension] : []
            content {
              key           = dimension.value.key
              match_options = dimension.value.match_options
              values        = dimension.value.values
            }
          }

          dynamic "tags" {
            for_each = not.value.tags != null ? [not.value.tags] : []
            content {
              key           = tags.value.key
              match_options = tags.value.match_options
              values        = tags.value.values
            }
          }
        }
      }

      dynamic "or" {
        for_each = threshold_expression.value.or != null ? threshold_expression.value.or : []
        content {
          dynamic "cost_category" {
            for_each = or.value.cost_category != null ? [or.value.cost_category] : []
            content {
              key           = cost_category.value.key
              match_options = cost_category.value.match_options
              values        = cost_category.value.values
            }
          }

          dynamic "dimension" {
            for_each = or.value.dimension != null ? [or.value.dimension] : []
            content {
              key           = dimension.value.key
              match_options = dimension.value.match_options
              values        = dimension.value.values
            }
          }

          dynamic "tags" {
            for_each = or.value.tags != null ? [or.value.tags] : []
            content {
              key           = tags.value.key
              match_options = tags.value.match_options
              values        = tags.value.values
            }
          }
        }
      }

      dynamic "tags" {
        for_each = threshold_expression.value.tags != null ? [threshold_expression.value.tags] : []
        content {
          key           = tags.value.key
          match_options = tags.value.match_options
          values        = tags.value.values
        }
      }
    }
  }
}