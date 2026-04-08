resource "aws_wafv2_web_acl_rule_group_association" "this" {
  rule_name       = var.rule_name
  priority        = var.priority
  web_acl_arn     = var.web_acl_arn
  override_action = var.override_action
  region          = var.region

  dynamic "managed_rule_group" {
    for_each = var.managed_rule_group != null ? [var.managed_rule_group] : []
    content {
      name        = managed_rule_group.value.name
      vendor_name = managed_rule_group.value.vendor_name
      version     = managed_rule_group.value.version

      dynamic "rule_action_override" {
        for_each = managed_rule_group.value.rule_action_override != null ? managed_rule_group.value.rule_action_override : []
        content {
          name = rule_action_override.value.name

          action_to_use {
            dynamic "allow" {
              for_each = rule_action_override.value.action_to_use.allow != null ? [rule_action_override.value.action_to_use.allow] : []
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
              for_each = rule_action_override.value.action_to_use.block != null ? [rule_action_override.value.action_to_use.block] : []
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
              for_each = rule_action_override.value.action_to_use.captcha != null ? [rule_action_override.value.action_to_use.captcha] : []
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
              for_each = rule_action_override.value.action_to_use.challenge != null ? [rule_action_override.value.action_to_use.challenge] : []
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
              for_each = rule_action_override.value.action_to_use.count != null ? [rule_action_override.value.action_to_use.count] : []
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
      }
    }
  }

  dynamic "rule_group_reference" {
    for_each = var.rule_group_reference != null ? [var.rule_group_reference] : []
    content {
      arn = rule_group_reference.value.arn

      dynamic "rule_action_override" {
        for_each = rule_group_reference.value.rule_action_override != null ? rule_group_reference.value.rule_action_override : []
        content {
          name = rule_action_override.value.name

          action_to_use {
            dynamic "allow" {
              for_each = rule_action_override.value.action_to_use.allow != null ? [rule_action_override.value.action_to_use.allow] : []
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
              for_each = rule_action_override.value.action_to_use.block != null ? [rule_action_override.value.action_to_use.block] : []
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
              for_each = rule_action_override.value.action_to_use.captcha != null ? [rule_action_override.value.action_to_use.captcha] : []
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
              for_each = rule_action_override.value.action_to_use.challenge != null ? [rule_action_override.value.action_to_use.challenge] : []
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
              for_each = rule_action_override.value.action_to_use.count != null ? [rule_action_override.value.action_to_use.count] : []
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
      }
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}