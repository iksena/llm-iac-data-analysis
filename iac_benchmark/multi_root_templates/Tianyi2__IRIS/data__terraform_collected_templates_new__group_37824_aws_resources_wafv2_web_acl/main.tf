resource "aws_wafv2_web_acl" "this" {
  region        = var.region
  description   = var.description
  name          = var.name
  name_prefix   = var.name_prefix
  rule_json     = var.rule_json
  scope         = var.scope
  tags          = var.tags
  token_domains = var.token_domains

  dynamic "association_config" {
    for_each = var.association_config != null ? [var.association_config] : []
    content {
      dynamic "request_body" {
        for_each = association_config.value.request_body != null ? [association_config.value.request_body] : []
        content {
          dynamic "api_gateway" {
            for_each = request_body.value.api_gateway != null ? [request_body.value.api_gateway] : []
            content {
              default_size_inspection_limit = api_gateway.value.default_size_inspection_limit
            }
          }

          dynamic "app_runner_service" {
            for_each = request_body.value.app_runner_service != null ? [request_body.value.app_runner_service] : []
            content {
              default_size_inspection_limit = app_runner_service.value.default_size_inspection_limit
            }
          }

          dynamic "cloudfront" {
            for_each = request_body.value.cloudfront != null ? [request_body.value.cloudfront] : []
            content {
              default_size_inspection_limit = cloudfront.value.default_size_inspection_limit
            }
          }

          dynamic "cognito_user_pool" {
            for_each = request_body.value.cognito_user_pool != null ? [request_body.value.cognito_user_pool] : []
            content {
              default_size_inspection_limit = cognito_user_pool.value.default_size_inspection_limit
            }
          }

          dynamic "verified_access_instance" {
            for_each = request_body.value.verified_access_instance != null ? [request_body.value.verified_access_instance] : []
            content {
              default_size_inspection_limit = verified_access_instance.value.default_size_inspection_limit
            }
          }
        }
      }
    }
  }

  dynamic "captcha_config" {
    for_each = var.captcha_config != null ? [var.captcha_config] : []
    content {
      dynamic "immunity_time_property" {
        for_each = captcha_config.value.immunity_time_property != null ? [captcha_config.value.immunity_time_property] : []
        content {
          immunity_time = immunity_time_property.value.immunity_time
        }
      }
    }
  }

  dynamic "challenge_config" {
    for_each = var.challenge_config != null ? [var.challenge_config] : []
    content {
      dynamic "immunity_time_property" {
        for_each = challenge_config.value.immunity_time_property != null ? [challenge_config.value.immunity_time_property] : []
        content {
          immunity_time = immunity_time_property.value.immunity_time
        }
      }
    }
  }

  dynamic "custom_response_body" {
    for_each = var.custom_response_body
    content {
      key          = custom_response_body.value.key
      content      = custom_response_body.value.content
      content_type = custom_response_body.value.content_type
    }
  }

  dynamic "data_protection_config" {
    for_each = var.data_protection_config != null ? [var.data_protection_config] : []
    content {
      dynamic "data_protection" {
        for_each = data_protection_config.value.data_protection
        content {
          action = data_protection.value.action
          field {
            field_type = data_protection.value.field.field_type
            field_keys = data_protection.value.field.field_keys
          }
          exclude_rate_based_details = data_protection.value.exclude_rate_based_details
          exclude_rule_match_details = data_protection.value.exclude_rule_match_details
        }
      }
    }
  }

  default_action {
    dynamic "allow" {
      for_each = var.default_action.allow != null ? [var.default_action.allow] : []
      content {
        dynamic "custom_request_handling" {
          for_each = allow.value.custom_request_handling != null ? [allow.value.custom_request_handling] : []
          content {
            dynamic "insert_header" {
              for_each = custom_request_handling.value.insert_header
              content {
                name  = insert_header.value.name
                value = insert_header.value.value
              }
            }
          }
        }
      }
    }

    dynamic "block" {
      for_each = var.default_action.block != null ? [var.default_action.block] : []
      content {
        dynamic "custom_response" {
          for_each = block.value.custom_response != null ? [block.value.custom_response] : []
          content {
            custom_response_body_key = custom_response.value.custom_response_body_key
            response_code            = custom_response.value.response_code

            dynamic "response_header" {
              for_each = custom_response.value.response_header != null ? custom_response.value.response_header : []
              content {
                name  = response_header.value.name
                value = response_header.value.value
              }
            }
          }
        }
      }
    }
  }

  dynamic "rule" {
    for_each = var.rule
    content {
      name     = rule.value.name
      priority = rule.value.priority

      dynamic "action" {
        for_each = rule.value.action != null ? [rule.value.action] : []
        content {
          dynamic "allow" {
            for_each = action.value.allow != null ? [action.value.allow] : []
            content {
              dynamic "custom_request_handling" {
                for_each = allow.value.custom_request_handling != null ? [allow.value.custom_request_handling] : []
                content {
                  dynamic "insert_header" {
                    for_each = custom_request_handling.value.insert_header
                    content {
                      name  = insert_header.value.name
                      value = insert_header.value.value
                    }
                  }
                }
              }
            }
          }

          dynamic "block" {
            for_each = action.value.block != null ? [action.value.block] : []
            content {
              dynamic "custom_response" {
                for_each = block.value.custom_response != null ? [block.value.custom_response] : []
                content {
                  custom_response_body_key = custom_response.value.custom_response_body_key
                  response_code            = custom_response.value.response_code

                  dynamic "response_header" {
                    for_each = custom_response.value.response_header != null ? custom_response.value.response_header : []
                    content {
                      name  = response_header.value.name
                      value = response_header.value.value
                    }
                  }
                }
              }
            }
          }

          dynamic "captcha" {
            for_each = action.value.captcha != null ? [action.value.captcha] : []
            content {
              dynamic "custom_request_handling" {
                for_each = captcha.value.custom_request_handling != null ? [captcha.value.custom_request_handling] : []
                content {
                  dynamic "insert_header" {
                    for_each = custom_request_handling.value.insert_header
                    content {
                      name  = insert_header.value.name
                      value = insert_header.value.value
                    }
                  }
                }
              }
            }
          }

          dynamic "challenge" {
            for_each = action.value.challenge != null ? [action.value.challenge] : []
            content {
              dynamic "custom_request_handling" {
                for_each = challenge.value.custom_request_handling != null ? [challenge.value.custom_request_handling] : []
                content {
                  dynamic "insert_header" {
                    for_each = custom_request_handling.value.insert_header
                    content {
                      name  = insert_header.value.name
                      value = insert_header.value.value
                    }
                  }
                }
              }
            }
          }

          dynamic "count" {
            for_each = action.value.count != null ? [action.value.count] : []
            content {
              dynamic "custom_request_handling" {
                for_each = count.value.custom_request_handling != null ? [count.value.custom_request_handling] : []
                content {
                  dynamic "insert_header" {
                    for_each = custom_request_handling.value.insert_header
                    content {
                      name  = insert_header.value.name
                      value = insert_header.value.value
                    }
                  }
                }
              }
            }
          }
        }
      }

      dynamic "captcha_config" {
        for_each = rule.value.captcha_config != null ? [rule.value.captcha_config] : []
        content {
          dynamic "immunity_time_property" {
            for_each = captcha_config.value.immunity_time_property != null ? [captcha_config.value.immunity_time_property] : []
            content {
              immunity_time = immunity_time_property.value.immunity_time
            }
          }
        }
      }

      dynamic "challenge_config" {
        for_each = rule.value.challenge_config != null ? [rule.value.challenge_config] : []
        content {
          dynamic "immunity_time_property" {
            for_each = challenge_config.value.immunity_time_property != null ? [challenge_config.value.immunity_time_property] : []
            content {
              immunity_time = immunity_time_property.value.immunity_time
            }
          }
        }
      }

      dynamic "override_action" {
        for_each = rule.value.override_action != null ? [rule.value.override_action] : []
        content {
          dynamic "count" {
            for_each = override_action.value.count != null ? [override_action.value.count] : []
            content {}
          }

          dynamic "none" {
            for_each = override_action.value.none != null ? [override_action.value.none] : []
            content {}
          }
        }
      }

      dynamic "rule_label" {
        for_each = rule.value.rule_label != null ? rule.value.rule_label : []
        content {
          name = rule_label.value.name
        }
      }

      dynamic "statement" {
        for_each = rule.value.statement != null ? [rule.value.statement] : []
        content {
          # Convert the "any" type statement to the appropriate block structure
          # This is a simplified approach - in practice, you'd need to handle all statement types
          # For now, we'll use the jsonencode/jsondecode approach
          dynamic "managed_rule_group_statement" {
            for_each = can(statement.value.managed_rule_group_statement) ? [statement.value.managed_rule_group_statement] : []
            content {
              name        = managed_rule_group_statement.value.name
              vendor_name = managed_rule_group_statement.value.vendor_name
              version     = try(managed_rule_group_statement.value.version, null)
            }
          }

          dynamic "geo_match_statement" {
            for_each = can(statement.value.geo_match_statement) ? [statement.value.geo_match_statement] : []
            content {
              country_codes = geo_match_statement.value.country_codes
            }
          }

          dynamic "ip_set_reference_statement" {
            for_each = can(statement.value.ip_set_reference_statement) ? [statement.value.ip_set_reference_statement] : []
            content {
              arn = ip_set_reference_statement.value.arn
            }
          }

          # Add more statement types as needed
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = rule.value.visibility_config.cloudwatch_metrics_enabled
        metric_name                = rule.value.visibility_config.metric_name
        sampled_requests_enabled   = rule.value.visibility_config.sampled_requests_enabled
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.visibility_config.cloudwatch_metrics_enabled
    metric_name                = var.visibility_config.metric_name
    sampled_requests_enabled   = var.visibility_config.sampled_requests_enabled
  }
}