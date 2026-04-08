resource "aws_wafv2_rule_group" "this" {
  region      = var.region
  capacity    = var.capacity
  description = var.description
  name        = var.name
  name_prefix = var.name_prefix
  scope       = var.scope
  rules_json  = var.rules_json
  tags        = var.tags

  dynamic "custom_response_body" {
    for_each = var.custom_response_body
    content {
      key          = custom_response_body.value.key
      content      = custom_response_body.value.content
      content_type = custom_response_body.value.content_type
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
                    for_each = custom_response.value.response_header
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

      dynamic "rule_label" {
        for_each = rule.value.rule_label
        content {
          name = rule_label.value.name
        }
      }

      dynamic "statement" {
        for_each = rule.value.statement != null ? [rule.value.statement] : []
        content {
          dynamic "and_statement" {
            for_each = statement.value.and_statement != null ? [statement.value.and_statement] : []
            content {
              dynamic "statement" {
                for_each = and_statement.value.statement
                iterator = and_stmt
                content {
                  # Note: This creates a nested statement structure
                  # The actual implementation would need to handle all nested statement types recursively
                  dynamic "byte_match_statement" {
                    for_each = and_stmt.value.byte_match_statement != null ? [and_stmt.value.byte_match_statement] : []
                    content {
                      positional_constraint = byte_match_statement.value.positional_constraint
                      search_string         = byte_match_statement.value.search_string

                      dynamic "field_to_match" {
                        for_each = byte_match_statement.value.field_to_match != null ? [byte_match_statement.value.field_to_match] : []
                        content {
                          dynamic "all_query_arguments" {
                            for_each = field_to_match.value.all_query_arguments != null ? [field_to_match.value.all_query_arguments] : []
                            content {}
                          }
                          dynamic "body" {
                            for_each = field_to_match.value.body != null ? [field_to_match.value.body] : []
                            content {}
                          }
                          dynamic "method" {
                            for_each = field_to_match.value.method != null ? [field_to_match.value.method] : []
                            content {}
                          }
                          dynamic "query_string" {
                            for_each = field_to_match.value.query_string != null ? [field_to_match.value.query_string] : []
                            content {}
                          }
                          dynamic "single_header" {
                            for_each = field_to_match.value.single_header != null ? [field_to_match.value.single_header] : []
                            content {
                              name = single_header.value.name
                            }
                          }
                          dynamic "single_query_argument" {
                            for_each = field_to_match.value.single_query_argument != null ? [field_to_match.value.single_query_argument] : []
                            content {
                              name = single_query_argument.value.name
                            }
                          }
                          dynamic "uri_path" {
                            for_each = field_to_match.value.uri_path != null ? [field_to_match.value.uri_path] : []
                            content {}
                          }
                          dynamic "uri_fragment" {
                            for_each = field_to_match.value.uri_fragment != null ? [field_to_match.value.uri_fragment] : []
                            content {
                              fallback_behavior = uri_fragment.value.fallback_behavior
                            }
                          }
                          dynamic "cookies" {
                            for_each = field_to_match.value.cookies != null ? [field_to_match.value.cookies] : []
                            content {
                              match_scope       = cookies.value.match_scope
                              oversize_handling = cookies.value.oversize_handling

                              dynamic "match_pattern" {
                                for_each = cookies.value.match_pattern != null ? [cookies.value.match_pattern] : []
                                content {
                                  dynamic "all" {
                                    for_each = match_pattern.value.all != null ? [match_pattern.value.all] : []
                                    content {}
                                  }
                                  included_cookies = match_pattern.value.included_cookies
                                  excluded_cookies = match_pattern.value.excluded_cookies
                                }
                              }
                            }
                          }
                          dynamic "headers" {
                            for_each = field_to_match.value.headers != null ? [field_to_match.value.headers] : []
                            content {
                              match_scope       = headers.value.match_scope
                              oversize_handling = headers.value.oversize_handling

                              dynamic "match_pattern" {
                                for_each = headers.value.match_pattern != null ? [headers.value.match_pattern] : []
                                content {
                                  dynamic "all" {
                                    for_each = match_pattern.value.all != null ? [match_pattern.value.all] : []
                                    content {}
                                  }
                                  included_headers = match_pattern.value.included_headers
                                  excluded_headers = match_pattern.value.excluded_headers
                                }
                              }
                            }
                          }
                          dynamic "header_order" {
                            for_each = field_to_match.value.header_order != null ? [field_to_match.value.header_order] : []
                            content {
                              oversize_handling = header_order.value.oversize_handling
                            }
                          }
                          dynamic "ja3_fingerprint" {
                            for_each = field_to_match.value.ja3_fingerprint != null ? [field_to_match.value.ja3_fingerprint] : []
                            content {
                              fallback_behavior = ja3_fingerprint.value.fallback_behavior
                            }
                          }
                          dynamic "ja4_fingerprint" {
                            for_each = field_to_match.value.ja4_fingerprint != null ? [field_to_match.value.ja4_fingerprint] : []
                            content {
                              fallback_behavior = ja4_fingerprint.value.fallback_behavior
                            }
                          }
                          dynamic "json_body" {
                            for_each = field_to_match.value.json_body != null ? [field_to_match.value.json_body] : []
                            content {
                              invalid_fallback_behavior = json_body.value.invalid_fallback_behavior
                              match_scope               = json_body.value.match_scope
                              oversize_handling         = json_body.value.oversize_handling

                              dynamic "match_pattern" {
                                for_each = json_body.value.match_pattern != null ? [json_body.value.match_pattern] : []
                                content {
                                  dynamic "all" {
                                    for_each = match_pattern.value.all != null ? [match_pattern.value.all] : []
                                    content {}
                                  }
                                  included_paths = match_pattern.value.included_paths
                                }
                              }
                            }
                          }
                        }
                      }

                      dynamic "text_transformation" {
                        for_each = byte_match_statement.value.text_transformation
                        content {
                          priority = text_transformation.value.priority
                          type     = text_transformation.value.type
                        }
                      }
                    }
                  }

                  dynamic "geo_match_statement" {
                    for_each = and_stmt.value.geo_match_statement != null ? [and_stmt.value.geo_match_statement] : []
                    content {
                      country_codes = geo_match_statement.value.country_codes

                      dynamic "forwarded_ip_config" {
                        for_each = geo_match_statement.value.forwarded_ip_config != null ? [geo_match_statement.value.forwarded_ip_config] : []
                        content {
                          fallback_behavior = forwarded_ip_config.value.fallback_behavior
                          header_name       = forwarded_ip_config.value.header_name
                        }
                      }
                    }
                  }

                  # Additional statement types would be added here...
                  # This is a simplified version - the full implementation would include all statement types
                }
              }
            }
          }

          dynamic "or_statement" {
            for_each = statement.value.or_statement != null ? [statement.value.or_statement] : []
            content {
              dynamic "statement" {
                for_each = or_statement.value.statement
                iterator = or_stmt
                content {
                  # Similar nested structure as and_statement
                  dynamic "regex_match_statement" {
                    for_each = or_stmt.value.regex_match_statement != null ? [or_stmt.value.regex_match_statement] : []
                    content {
                      regex_string = regex_match_statement.value.regex_string

                      dynamic "field_to_match" {
                        for_each = regex_match_statement.value.field_to_match != null ? [regex_match_statement.value.field_to_match] : []
                        content {
                          # Same field_to_match structure as above
                          dynamic "single_header" {
                            for_each = field_to_match.value.single_header != null ? [field_to_match.value.single_header] : []
                            content {
                              name = single_header.value.name
                            }
                          }
                          dynamic "body" {
                            for_each = field_to_match.value.body != null ? [field_to_match.value.body] : []
                            content {}
                          }
                          dynamic "method" {
                            for_each = field_to_match.value.method != null ? [field_to_match.value.method] : []
                            content {}
                          }
                        }
                      }

                      dynamic "text_transformation" {
                        for_each = regex_match_statement.value.text_transformation
                        content {
                          priority = text_transformation.value.priority
                          type     = text_transformation.value.type
                        }
                      }
                    }
                  }

                  dynamic "sqli_match_statement" {
                    for_each = or_stmt.value.sqli_match_statement != null ? [or_stmt.value.sqli_match_statement] : []
                    content {
                      sensitivity_level = sqli_match_statement.value.sensitivity_level

                      dynamic "field_to_match" {
                        for_each = sqli_match_statement.value.field_to_match != null ? [sqli_match_statement.value.field_to_match] : []
                        content {
                          dynamic "body" {
                            for_each = field_to_match.value.body != null ? [field_to_match.value.body] : []
                            content {}
                          }
                        }
                      }

                      dynamic "text_transformation" {
                        for_each = sqli_match_statement.value.text_transformation
                        content {
                          priority = text_transformation.value.priority
                          type     = text_transformation.value.type
                        }
                      }
                    }
                  }

                  dynamic "xss_match_statement" {
                    for_each = or_stmt.value.xss_match_statement != null ? [or_stmt.value.xss_match_statement] : []
                    content {
                      dynamic "field_to_match" {
                        for_each = xss_match_statement.value.field_to_match != null ? [xss_match_statement.value.field_to_match] : []
                        content {
                          dynamic "method" {
                            for_each = field_to_match.value.method != null ? [field_to_match.value.method] : []
                            content {}
                          }
                        }
                      }

                      dynamic "text_transformation" {
                        for_each = xss_match_statement.value.text_transformation
                        content {
                          priority = text_transformation.value.priority
                          type     = text_transformation.value.type
                        }
                      }
                    }
                  }

                  dynamic "ip_set_reference_statement" {
                    for_each = or_stmt.value.ip_set_reference_statement != null ? [or_stmt.value.ip_set_reference_statement] : []
                    content {
                      arn = ip_set_reference_statement.value.arn

                      dynamic "ip_set_forwarded_ip_config" {
                        for_each = ip_set_reference_statement.value.ip_set_forwarded_ip_config != null ? [ip_set_reference_statement.value.ip_set_forwarded_ip_config] : []
                        content {
                          fallback_behavior = ip_set_forwarded_ip_config.value.fallback_behavior
                          header_name       = ip_set_forwarded_ip_config.value.header_name
                          position          = ip_set_forwarded_ip_config.value.position
                        }
                      }
                    }
                  }

                  dynamic "regex_pattern_set_reference_statement" {
                    for_each = or_stmt.value.regex_pattern_set_reference_statement != null ? [or_stmt.value.regex_pattern_set_reference_statement] : []
                    content {
                      arn = regex_pattern_set_reference_statement.value.arn

                      dynamic "field_to_match" {
                        for_each = regex_pattern_set_reference_statement.value.field_to_match != null ? [regex_pattern_set_reference_statement.value.field_to_match] : []
                        content {
                          dynamic "single_header" {
                            for_each = field_to_match.value.single_header != null ? [field_to_match.value.single_header] : []
                            content {
                              name = single_header.value.name
                            }
                          }
                        }
                      }

                      dynamic "text_transformation" {
                        for_each = regex_pattern_set_reference_statement.value.text_transformation
                        content {
                          priority = text_transformation.value.priority
                          type     = text_transformation.value.type
                        }
                      }
                    }
                  }
                }
              }
            }
          }

          dynamic "not_statement" {
            for_each = statement.value.not_statement != null ? [statement.value.not_statement] : []
            content {
              dynamic "statement" {
                for_each = not_statement.value.statement != null ? [not_statement.value.statement] : []
                iterator = not_stmt
                content {
                  # Same nested statement structure...
                  dynamic "and_statement" {
                    for_each = not_stmt.value.and_statement != null ? [not_stmt.value.and_statement] : []
                    content {
                      dynamic "statement" {
                        for_each = and_statement.value.statement
                        iterator = nested_and_stmt
                        content {
                          dynamic "geo_match_statement" {
                            for_each = nested_and_stmt.value.geo_match_statement != null ? [nested_and_stmt.value.geo_match_statement] : []
                            content {
                              country_codes = geo_match_statement.value.country_codes

                              dynamic "forwarded_ip_config" {
                                for_each = geo_match_statement.value.forwarded_ip_config != null ? [geo_match_statement.value.forwarded_ip_config] : []
                                content {
                                  fallback_behavior = forwarded_ip_config.value.fallback_behavior
                                  header_name       = forwarded_ip_config.value.header_name
                                }
                              }
                            }
                          }

                          dynamic "byte_match_statement" {
                            for_each = nested_and_stmt.value.byte_match_statement != null ? [nested_and_stmt.value.byte_match_statement] : []
                            content {
                              positional_constraint = byte_match_statement.value.positional_constraint
                              search_string         = byte_match_statement.value.search_string

                              dynamic "field_to_match" {
                                for_each = byte_match_statement.value.field_to_match != null ? [byte_match_statement.value.field_to_match] : []
                                content {
                                  dynamic "all_query_arguments" {
                                    for_each = field_to_match.value.all_query_arguments != null ? [field_to_match.value.all_query_arguments] : []
                                    content {}
                                  }
                                }
                              }

                              dynamic "text_transformation" {
                                for_each = byte_match_statement.value.text_transformation
                                content {
                                  priority = text_transformation.value.priority
                                  type     = text_transformation.value.type
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
          }

          dynamic "size_constraint_statement" {
            for_each = statement.value.size_constraint_statement != null ? [statement.value.size_constraint_statement] : []
            content {
              comparison_operator = size_constraint_statement.value.comparison_operator
              size                = size_constraint_statement.value.size

              dynamic "field_to_match" {
                for_each = size_constraint_statement.value.field_to_match != null ? [size_constraint_statement.value.field_to_match] : []
                content {
                  dynamic "single_query_argument" {
                    for_each = field_to_match.value.single_query_argument != null ? [field_to_match.value.single_query_argument] : []
                    content {
                      name = single_query_argument.value.name
                    }
                  }
                }
              }

              dynamic "text_transformation" {
                for_each = size_constraint_statement.value.text_transformation
                content {
                  priority = text_transformation.value.priority
                  type     = text_transformation.value.type
                }
              }
            }
          }

          dynamic "rate_based_statement" {
            for_each = statement.value.rate_based_statement != null ? [statement.value.rate_based_statement] : []
            content {
              aggregate_key_type    = rate_based_statement.value.aggregate_key_type
              evaluation_window_sec = rate_based_statement.value.evaluation_window_sec
              limit                 = rate_based_statement.value.limit

              dynamic "custom_key" {
                for_each = rate_based_statement.value.custom_key
                content {
                  dynamic "cookie" {
                    for_each = custom_key.value.cookie != null ? [custom_key.value.cookie] : []
                    content {
                      name = cookie.value.name

                      dynamic "text_transformation" {
                        for_each = cookie.value.text_transformation
                        content {
                          priority = text_transformation.value.priority
                          type     = text_transformation.value.type
                        }
                      }
                    }
                  }

                  dynamic "forwarded_ip" {
                    for_each = custom_key.value.forwarded_ip != null ? [custom_key.value.forwarded_ip] : []
                    content {}
                  }

                  dynamic "header" {
                    for_each = custom_key.value.header != null ? [custom_key.value.header] : []
                    content {
                      name = header.value.name

                      dynamic "text_transformation" {
                        for_each = header.value.text_transformation
                        content {
                          priority = text_transformation.value.priority
                          type     = text_transformation.value.type
                        }
                      }
                    }
                  }

                  dynamic "http_method" {
                    for_each = custom_key.value.http_method != null ? [custom_key.value.http_method] : []
                    content {}
                  }

                  dynamic "ip" {
                    for_each = custom_key.value.ip != null ? [custom_key.value.ip] : []
                    content {}
                  }

                  dynamic "ja3_fingerprint" {
                    for_each = custom_key.value.ja3_fingerprint != null ? [custom_key.value.ja3_fingerprint] : []
                    content {
                      fallback_behavior = ja3_fingerprint.value.fallback_behavior
                    }
                  }

                  dynamic "ja4_fingerprint" {
                    for_each = custom_key.value.ja4_fingerprint != null ? [custom_key.value.ja4_fingerprint] : []
                    content {
                      fallback_behavior = ja4_fingerprint.value.fallback_behavior
                    }
                  }

                  dynamic "label_namespace" {
                    for_each = custom_key.value.label_namespace != null ? [custom_key.value.label_namespace] : []
                    content {
                      namespace = label_namespace.value.namespace
                    }
                  }

                  dynamic "query_argument" {
                    for_each = custom_key.value.query_argument != null ? [custom_key.value.query_argument] : []
                    content {
                      name = query_argument.value.name

                      dynamic "text_transformation" {
                        for_each = query_argument.value.text_transformation
                        content {
                          priority = text_transformation.value.priority
                          type     = text_transformation.value.type
                        }
                      }
                    }
                  }

                  dynamic "query_string" {
                    for_each = custom_key.value.query_string != null ? [custom_key.value.query_string] : []
                    content {
                      dynamic "text_transformation" {
                        for_each = query_string.value.text_transformation
                        content {
                          priority = text_transformation.value.priority
                          type     = text_transformation.value.type
                        }
                      }
                    }
                  }

                  dynamic "uri_path" {
                    for_each = custom_key.value.uri_path != null ? [custom_key.value.uri_path] : []
                    content {
                      dynamic "text_transformation" {
                        for_each = uri_path.value.text_transformation
                        content {
                          priority = text_transformation.value.priority
                          type     = text_transformation.value.type
                        }
                      }
                    }
                  }
                }
              }

              dynamic "forwarded_ip_config" {
                for_each = rate_based_statement.value.forwarded_ip_config != null ? [rate_based_statement.value.forwarded_ip_config] : []
                content {
                  fallback_behavior = forwarded_ip_config.value.fallback_behavior
                  header_name       = forwarded_ip_config.value.header_name
                }
              }

              dynamic "scope_down_statement" {
                for_each = rate_based_statement.value.scope_down_statement != null ? [rate_based_statement.value.scope_down_statement] : []
                content {
                  # Nested statement structure for scope down
                  dynamic "byte_match_statement" {
                    for_each = scope_down_statement.value.byte_match_statement != null ? [scope_down_statement.value.byte_match_statement] : []
                    content {
                      positional_constraint = byte_match_statement.value.positional_constraint
                      search_string         = byte_match_statement.value.search_string

                      dynamic "field_to_match" {
                        for_each = byte_match_statement.value.field_to_match != null ? [byte_match_statement.value.field_to_match] : []
                        content {
                          dynamic "all_query_arguments" {
                            for_each = field_to_match.value.all_query_arguments != null ? [field_to_match.value.all_query_arguments] : []
                            content {}
                          }
                        }
                      }

                      dynamic "text_transformation" {
                        for_each = byte_match_statement.value.text_transformation
                        content {
                          priority = text_transformation.value.priority
                          type     = text_transformation.value.type
                        }
                      }
                    }
                  }
                }
              }
            }
          }

          dynamic "asn_match_statement" {
            for_each = statement.value.asn_match_statement != null ? [statement.value.asn_match_statement] : []
            content {
              asn_list = asn_match_statement.value.asn_list

              dynamic "forwarded_ip_config" {
                for_each = asn_match_statement.value.forwarded_ip_config != null ? [asn_match_statement.value.forwarded_ip_config] : []
                content {
                  fallback_behavior = forwarded_ip_config.value.fallback_behavior
                  header_name       = forwarded_ip_config.value.header_name
                }
              }
            }
          }

          dynamic "label_match_statement" {
            for_each = statement.value.label_match_statement != null ? [statement.value.label_match_statement] : []
            content {
              scope = label_match_statement.value.scope
              key   = label_match_statement.value.key
            }
          }

          # Add remaining single statement types
          dynamic "byte_match_statement" {
            for_each = statement.value.byte_match_statement != null ? [statement.value.byte_match_statement] : []
            content {
              positional_constraint = byte_match_statement.value.positional_constraint
              search_string         = byte_match_statement.value.search_string

              dynamic "field_to_match" {
                for_each = byte_match_statement.value.field_to_match != null ? [byte_match_statement.value.field_to_match] : []
                content {
                  dynamic "all_query_arguments" {
                    for_each = field_to_match.value.all_query_arguments != null ? [field_to_match.value.all_query_arguments] : []
                    content {}
                  }
                  dynamic "body" {
                    for_each = field_to_match.value.body != null ? [field_to_match.value.body] : []
                    content {}
                  }
                  dynamic "method" {
                    for_each = field_to_match.value.method != null ? [field_to_match.value.method] : []
                    content {}
                  }
                  dynamic "query_string" {
                    for_each = field_to_match.value.query_string != null ? [field_to_match.value.query_string] : []
                    content {}
                  }
                  dynamic "uri_path" {
                    for_each = field_to_match.value.uri_path != null ? [field_to_match.value.uri_path] : []
                    content {}
                  }
                  dynamic "single_header" {
                    for_each = field_to_match.value.single_header != null ? [field_to_match.value.single_header] : []
                    content {
                      name = single_header.value.name
                    }
                  }
                  dynamic "single_query_argument" {
                    for_each = field_to_match.value.single_query_argument != null ? [field_to_match.value.single_query_argument] : []
                    content {
                      name = single_query_argument.value.name
                    }
                  }
                  dynamic "uri_fragment" {
                    for_each = field_to_match.value.uri_fragment != null ? [field_to_match.value.uri_fragment] : []
                    content {
                      fallback_behavior = uri_fragment.value.fallback_behavior
                    }
                  }
                  dynamic "cookies" {
                    for_each = field_to_match.value.cookies != null ? [field_to_match.value.cookies] : []
                    content {
                      match_scope       = cookies.value.match_scope
                      oversize_handling = cookies.value.oversize_handling

                      dynamic "match_pattern" {
                        for_each = cookies.value.match_pattern != null ? [cookies.value.match_pattern] : []
                        content {
                          dynamic "all" {
                            for_each = match_pattern.value.all != null ? [match_pattern.value.all] : []
                            content {}
                          }
                          included_cookies = match_pattern.value.included_cookies
                          excluded_cookies = match_pattern.value.excluded_cookies
                        }
                      }
                    }
                  }
                  dynamic "headers" {
                    for_each = field_to_match.value.headers != null ? [field_to_match.value.headers] : []
                    content {
                      match_scope       = headers.value.match_scope
                      oversize_handling = headers.value.oversize_handling

                      dynamic "match_pattern" {
                        for_each = headers.value.match_pattern != null ? [headers.value.match_pattern] : []
                        content {
                          dynamic "all" {
                            for_each = match_pattern.value.all != null ? [match_pattern.value.all] : []
                            content {}
                          }
                          included_headers = match_pattern.value.included_headers
                          excluded_headers = match_pattern.value.excluded_headers
                        }
                      }
                    }
                  }
                  dynamic "header_order" {
                    for_each = field_to_match.value.header_order != null ? [field_to_match.value.header_order] : []
                    content {
                      oversize_handling = header_order.value.oversize_handling
                    }
                  }
                  dynamic "ja3_fingerprint" {
                    for_each = field_to_match.value.ja3_fingerprint != null ? [field_to_match.value.ja3_fingerprint] : []
                    content {
                      fallback_behavior = ja3_fingerprint.value.fallback_behavior
                    }
                  }
                  dynamic "ja4_fingerprint" {
                    for_each = field_to_match.value.ja4_fingerprint != null ? [field_to_match.value.ja4_fingerprint] : []
                    content {
                      fallback_behavior = ja4_fingerprint.value.fallback_behavior
                    }
                  }
                  dynamic "json_body" {
                    for_each = field_to_match.value.json_body != null ? [field_to_match.value.json_body] : []
                    content {
                      invalid_fallback_behavior = json_body.value.invalid_fallback_behavior
                      match_scope               = json_body.value.match_scope
                      oversize_handling         = json_body.value.oversize_handling

                      dynamic "match_pattern" {
                        for_each = json_body.value.match_pattern != null ? [json_body.value.match_pattern] : []
                        content {
                          dynamic "all" {
                            for_each = match_pattern.value.all != null ? [match_pattern.value.all] : []
                            content {}
                          }
                          included_paths = match_pattern.value.included_paths
                        }
                      }
                    }
                  }
                }
              }

              dynamic "text_transformation" {
                for_each = byte_match_statement.value.text_transformation
                content {
                  priority = text_transformation.value.priority
                  type     = text_transformation.value.type
                }
              }
            }
          }

          dynamic "geo_match_statement" {
            for_each = statement.value.geo_match_statement != null ? [statement.value.geo_match_statement] : []
            content {
              country_codes = geo_match_statement.value.country_codes

              dynamic "forwarded_ip_config" {
                for_each = geo_match_statement.value.forwarded_ip_config != null ? [geo_match_statement.value.forwarded_ip_config] : []
                content {
                  fallback_behavior = forwarded_ip_config.value.fallback_behavior
                  header_name       = forwarded_ip_config.value.header_name
                }
              }
            }
          }

          dynamic "ip_set_reference_statement" {
            for_each = statement.value.ip_set_reference_statement != null ? [statement.value.ip_set_reference_statement] : []
            content {
              arn = ip_set_reference_statement.value.arn

              dynamic "ip_set_forwarded_ip_config" {
                for_each = ip_set_reference_statement.value.ip_set_forwarded_ip_config != null ? [ip_set_reference_statement.value.ip_set_forwarded_ip_config] : []
                content {
                  fallback_behavior = ip_set_forwarded_ip_config.value.fallback_behavior
                  header_name       = ip_set_forwarded_ip_config.value.header_name
                  position          = ip_set_forwarded_ip_config.value.position
                }
              }
            }
          }

          dynamic "regex_match_statement" {
            for_each = statement.value.regex_match_statement != null ? [statement.value.regex_match_statement] : []
            content {
              regex_string = regex_match_statement.value.regex_string

              dynamic "field_to_match" {
                for_each = regex_match_statement.value.field_to_match != null ? [regex_match_statement.value.field_to_match] : []
                content {
                  dynamic "all_query_arguments" {
                    for_each = field_to_match.value.all_query_arguments != null ? [field_to_match.value.all_query_arguments] : []
                    content {}
                  }
                  dynamic "body" {
                    for_each = field_to_match.value.body != null ? [field_to_match.value.body] : []
                    content {}
                  }
                  dynamic "method" {
                    for_each = field_to_match.value.method != null ? [field_to_match.value.method] : []
                    content {}
                  }
                  dynamic "query_string" {
                    for_each = field_to_match.value.query_string != null ? [field_to_match.value.query_string] : []
                    content {}
                  }
                  dynamic "uri_path" {
                    for_each = field_to_match.value.uri_path != null ? [field_to_match.value.uri_path] : []
                    content {}
                  }
                  dynamic "single_header" {
                    for_each = field_to_match.value.single_header != null ? [field_to_match.value.single_header] : []
                    content {
                      name = single_header.value.name
                    }
                  }
                  dynamic "single_query_argument" {
                    for_each = field_to_match.value.single_query_argument != null ? [field_to_match.value.single_query_argument] : []
                    content {
                      name = single_query_argument.value.name
                    }
                  }
                  dynamic "uri_fragment" {
                    for_each = field_to_match.value.uri_fragment != null ? [field_to_match.value.uri_fragment] : []
                    content {
                      fallback_behavior = uri_fragment.value.fallback_behavior
                    }
                  }
                  dynamic "cookies" {
                    for_each = field_to_match.value.cookies != null ? [field_to_match.value.cookies] : []
                    content {
                      match_scope       = cookies.value.match_scope
                      oversize_handling = cookies.value.oversize_handling

                      dynamic "match_pattern" {
                        for_each = cookies.value.match_pattern != null ? [cookies.value.match_pattern] : []
                        content {
                          dynamic "all" {
                            for_each = match_pattern.value.all != null ? [match_pattern.value.all] : []
                            content {}
                          }
                          included_cookies = match_pattern.value.included_cookies
                          excluded_cookies = match_pattern.value.excluded_cookies
                        }
                      }
                    }
                  }
                  dynamic "headers" {
                    for_each = field_to_match.value.headers != null ? [field_to_match.value.headers] : []
                    content {
                      match_scope       = headers.value.match_scope
                      oversize_handling = headers.value.oversize_handling

                      dynamic "match_pattern" {
                        for_each = headers.value.match_pattern != null ? [headers.value.match_pattern] : []
                        content {
                          dynamic "all" {
                            for_each = match_pattern.value.all != null ? [match_pattern.value.all] : []
                            content {}
                          }
                          included_headers = match_pattern.value.included_headers
                          excluded_headers = match_pattern.value.excluded_headers
                        }
                      }
                    }
                  }
                  dynamic "header_order" {
                    for_each = field_to_match.value.header_order != null ? [field_to_match.value.header_order] : []
                    content {
                      oversize_handling = header_order.value.oversize_handling
                    }
                  }
                  dynamic "ja3_fingerprint" {
                    for_each = field_to_match.value.ja3_fingerprint != null ? [field_to_match.value.ja3_fingerprint] : []
                    content {
                      fallback_behavior = ja3_fingerprint.value.fallback_behavior
                    }
                  }
                  dynamic "ja4_fingerprint" {
                    for_each = field_to_match.value.ja4_fingerprint != null ? [field_to_match.value.ja4_fingerprint] : []
                    content {
                      fallback_behavior = ja4_fingerprint.value.fallback_behavior
                    }
                  }
                  dynamic "json_body" {
                    for_each = field_to_match.value.json_body != null ? [field_to_match.value.json_body] : []
                    content {
                      invalid_fallback_behavior = json_body.value.invalid_fallback_behavior
                      match_scope               = json_body.value.match_scope
                      oversize_handling         = json_body.value.oversize_handling

                      dynamic "match_pattern" {
                        for_each = json_body.value.match_pattern != null ? [json_body.value.match_pattern] : []
                        content {
                          dynamic "all" {
                            for_each = match_pattern.value.all != null ? [match_pattern.value.all] : []
                            content {}
                          }
                          included_paths = match_pattern.value.included_paths
                        }
                      }
                    }
                  }
                }
              }

              dynamic "text_transformation" {
                for_each = regex_match_statement.value.text_transformation
                content {
                  priority = text_transformation.value.priority
                  type     = text_transformation.value.type
                }
              }
            }
          }

          dynamic "regex_pattern_set_reference_statement" {
            for_each = statement.value.regex_pattern_set_reference_statement != null ? [statement.value.regex_pattern_set_reference_statement] : []
            content {
              arn = regex_pattern_set_reference_statement.value.arn

              dynamic "field_to_match" {
                for_each = regex_pattern_set_reference_statement.value.field_to_match != null ? [regex_pattern_set_reference_statement.value.field_to_match] : []
                content {
                  dynamic "all_query_arguments" {
                    for_each = field_to_match.value.all_query_arguments != null ? [field_to_match.value.all_query_arguments] : []
                    content {}
                  }
                  dynamic "body" {
                    for_each = field_to_match.value.body != null ? [field_to_match.value.body] : []
                    content {}
                  }
                  dynamic "method" {
                    for_each = field_to_match.value.method != null ? [field_to_match.value.method] : []
                    content {}
                  }
                  dynamic "query_string" {
                    for_each = field_to_match.value.query_string != null ? [field_to_match.value.query_string] : []
                    content {}
                  }
                  dynamic "uri_path" {
                    for_each = field_to_match.value.uri_path != null ? [field_to_match.value.uri_path] : []
                    content {}
                  }
                  dynamic "single_header" {
                    for_each = field_to_match.value.single_header != null ? [field_to_match.value.single_header] : []
                    content {
                      name = single_header.value.name
                    }
                  }
                  dynamic "single_query_argument" {
                    for_each = field_to_match.value.single_query_argument != null ? [field_to_match.value.single_query_argument] : []
                    content {
                      name = single_query_argument.value.name
                    }
                  }
                  dynamic "uri_fragment" {
                    for_each = field_to_match.value.uri_fragment != null ? [field_to_match.value.uri_fragment] : []
                    content {
                      fallback_behavior = uri_fragment.value.fallback_behavior
                    }
                  }
                  dynamic "cookies" {
                    for_each = field_to_match.value.cookies != null ? [field_to_match.value.cookies] : []
                    content {
                      match_scope       = cookies.value.match_scope
                      oversize_handling = cookies.value.oversize_handling

                      dynamic "match_pattern" {
                        for_each = cookies.value.match_pattern != null ? [cookies.value.match_pattern] : []
                        content {
                          dynamic "all" {
                            for_each = match_pattern.value.all != null ? [match_pattern.value.all] : []
                            content {}
                          }
                          included_cookies = match_pattern.value.included_cookies
                          excluded_cookies = match_pattern.value.excluded_cookies
                        }
                      }
                    }
                  }
                  dynamic "headers" {
                    for_each = field_to_match.value.headers != null ? [field_to_match.value.headers] : []
                    content {
                      match_scope       = headers.value.match_scope
                      oversize_handling = headers.value.oversize_handling

                      dynamic "match_pattern" {
                        for_each = headers.value.match_pattern != null ? [headers.value.match_pattern] : []
                        content {
                          dynamic "all" {
                            for_each = match_pattern.value.all != null ? [match_pattern.value.all] : []
                            content {}
                          }
                          included_headers = match_pattern.value.included_headers
                          excluded_headers = match_pattern.value.excluded_headers
                        }
                      }
                    }
                  }
                  dynamic "header_order" {
                    for_each = field_to_match.value.header_order != null ? [field_to_match.value.header_order] : []
                    content {
                      oversize_handling = header_order.value.oversize_handling
                    }
                  }
                  dynamic "ja3_fingerprint" {
                    for_each = field_to_match.value.ja3_fingerprint != null ? [field_to_match.value.ja3_fingerprint] : []
                    content {
                      fallback_behavior = ja3_fingerprint.value.fallback_behavior
                    }
                  }
                  dynamic "ja4_fingerprint" {
                    for_each = field_to_match.value.ja4_fingerprint != null ? [field_to_match.value.ja4_fingerprint] : []
                    content {
                      fallback_behavior = ja4_fingerprint.value.fallback_behavior
                    }
                  }
                  dynamic "json_body" {
                    for_each = field_to_match.value.json_body != null ? [field_to_match.value.json_body] : []
                    content {
                      invalid_fallback_behavior = json_body.value.invalid_fallback_behavior
                      match_scope               = json_body.value.match_scope
                      oversize_handling         = json_body.value.oversize_handling

                      dynamic "match_pattern" {
                        for_each = json_body.value.match_pattern != null ? [json_body.value.match_pattern] : []
                        content {
                          dynamic "all" {
                            for_each = match_pattern.value.all != null ? [match_pattern.value.all] : []
                            content {}
                          }
                          included_paths = match_pattern.value.included_paths
                        }
                      }
                    }
                  }
                }
              }

              dynamic "text_transformation" {
                for_each = regex_pattern_set_reference_statement.value.text_transformation
                content {
                  priority = text_transformation.value.priority
                  type     = text_transformation.value.type
                }
              }
            }
          }

          dynamic "sqli_match_statement" {
            for_each = statement.value.sqli_match_statement != null ? [statement.value.sqli_match_statement] : []
            content {
              sensitivity_level = sqli_match_statement.value.sensitivity_level

              dynamic "field_to_match" {
                for_each = sqli_match_statement.value.field_to_match != null ? [sqli_match_statement.value.field_to_match] : []
                content {
                  dynamic "all_query_arguments" {
                    for_each = field_to_match.value.all_query_arguments != null ? [field_to_match.value.all_query_arguments] : []
                    content {}
                  }
                  dynamic "body" {
                    for_each = field_to_match.value.body != null ? [field_to_match.value.body] : []
                    content {}
                  }
                  dynamic "method" {
                    for_each = field_to_match.value.method != null ? [field_to_match.value.method] : []
                    content {}
                  }
                  dynamic "query_string" {
                    for_each = field_to_match.value.query_string != null ? [field_to_match.value.query_string] : []
                    content {}
                  }
                  dynamic "uri_path" {
                    for_each = field_to_match.value.uri_path != null ? [field_to_match.value.uri_path] : []
                    content {}
                  }
                  dynamic "single_header" {
                    for_each = field_to_match.value.single_header != null ? [field_to_match.value.single_header] : []
                    content {
                      name = single_header.value.name
                    }
                  }
                  dynamic "single_query_argument" {
                    for_each = field_to_match.value.single_query_argument != null ? [field_to_match.value.single_query_argument] : []
                    content {
                      name = single_query_argument.value.name
                    }
                  }
                  dynamic "uri_fragment" {
                    for_each = field_to_match.value.uri_fragment != null ? [field_to_match.value.uri_fragment] : []
                    content {
                      fallback_behavior = uri_fragment.value.fallback_behavior
                    }
                  }
                  dynamic "cookies" {
                    for_each = field_to_match.value.cookies != null ? [field_to_match.value.cookies] : []
                    content {
                      match_scope       = cookies.value.match_scope
                      oversize_handling = cookies.value.oversize_handling

                      dynamic "match_pattern" {
                        for_each = cookies.value.match_pattern != null ? [cookies.value.match_pattern] : []
                        content {
                          dynamic "all" {
                            for_each = match_pattern.value.all != null ? [match_pattern.value.all] : []
                            content {}
                          }
                          included_cookies = match_pattern.value.included_cookies
                          excluded_cookies = match_pattern.value.excluded_cookies
                        }
                      }
                    }
                  }
                  dynamic "headers" {
                    for_each = field_to_match.value.headers != null ? [field_to_match.value.headers] : []
                    content {
                      match_scope       = headers.value.match_scope
                      oversize_handling = headers.value.oversize_handling

                      dynamic "match_pattern" {
                        for_each = headers.value.match_pattern != null ? [headers.value.match_pattern] : []
                        content {
                          dynamic "all" {
                            for_each = match_pattern.value.all != null ? [match_pattern.value.all] : []
                            content {}
                          }
                          included_headers = match_pattern.value.included_headers
                          excluded_headers = match_pattern.value.excluded_headers
                        }
                      }
                    }
                  }
                  dynamic "header_order" {
                    for_each = field_to_match.value.header_order != null ? [field_to_match.value.header_order] : []
                    content {
                      oversize_handling = header_order.value.oversize_handling
                    }
                  }
                  dynamic "ja3_fingerprint" {
                    for_each = field_to_match.value.ja3_fingerprint != null ? [field_to_match.value.ja3_fingerprint] : []
                    content {
                      fallback_behavior = ja3_fingerprint.value.fallback_behavior
                    }
                  }
                  dynamic "ja4_fingerprint" {
                    for_each = field_to_match.value.ja4_fingerprint != null ? [field_to_match.value.ja4_fingerprint] : []
                    content {
                      fallback_behavior = ja4_fingerprint.value.fallback_behavior
                    }
                  }
                  dynamic "json_body" {
                    for_each = field_to_match.value.json_body != null ? [field_to_match.value.json_body] : []
                    content {
                      invalid_fallback_behavior = json_body.value.invalid_fallback_behavior
                      match_scope               = json_body.value.match_scope
                      oversize_handling         = json_body.value.oversize_handling

                      dynamic "match_pattern" {
                        for_each = json_body.value.match_pattern != null ? [json_body.value.match_pattern] : []
                        content {
                          dynamic "all" {
                            for_each = match_pattern.value.all != null ? [match_pattern.value.all] : []
                            content {}
                          }
                          included_paths = match_pattern.value.included_paths
                        }
                      }
                    }
                  }
                }
              }

              dynamic "text_transformation" {
                for_each = sqli_match_statement.value.text_transformation
                content {
                  priority = text_transformation.value.priority
                  type     = text_transformation.value.type
                }
              }
            }
          }

          dynamic "xss_match_statement" {
            for_each = statement.value.xss_match_statement != null ? [statement.value.xss_match_statement] : []
            content {
              dynamic "field_to_match" {
                for_each = xss_match_statement.value.field_to_match != null ? [xss_match_statement.value.field_to_match] : []
                content {
                  dynamic "all_query_arguments" {
                    for_each = field_to_match.value.all_query_arguments != null ? [field_to_match.value.all_query_arguments] : []
                    content {}
                  }
                  dynamic "body" {
                    for_each = field_to_match.value.body != null ? [field_to_match.value.body] : []
                    content {}
                  }
                  dynamic "method" {
                    for_each = field_to_match.value.method != null ? [field_to_match.value.method] : []
                    content {}
                  }
                  dynamic "query_string" {
                    for_each = field_to_match.value.query_string != null ? [field_to_match.value.query_string] : []
                    content {}
                  }
                  dynamic "uri_path" {
                    for_each = field_to_match.value.uri_path != null ? [field_to_match.value.uri_path] : []
                    content {}
                  }
                  dynamic "single_header" {
                    for_each = field_to_match.value.single_header != null ? [field_to_match.value.single_header] : []
                    content {
                      name = single_header.value.name
                    }
                  }
                  dynamic "single_query_argument" {
                    for_each = field_to_match.value.single_query_argument != null ? [field_to_match.value.single_query_argument] : []
                    content {
                      name = single_query_argument.value.name
                    }
                  }
                  dynamic "uri_fragment" {
                    for_each = field_to_match.value.uri_fragment != null ? [field_to_match.value.uri_fragment] : []
                    content {
                      fallback_behavior = uri_fragment.value.fallback_behavior
                    }
                  }
                  dynamic "cookies" {
                    for_each = field_to_match.value.cookies != null ? [field_to_match.value.cookies] : []
                    content {
                      match_scope       = cookies.value.match_scope
                      oversize_handling = cookies.value.oversize_handling

                      dynamic "match_pattern" {
                        for_each = cookies.value.match_pattern != null ? [cookies.value.match_pattern] : []
                        content {
                          dynamic "all" {
                            for_each = match_pattern.value.all != null ? [match_pattern.value.all] : []
                            content {}
                          }
                          included_cookies = match_pattern.value.included_cookies
                          excluded_cookies = match_pattern.value.excluded_cookies
                        }
                      }
                    }
                  }
                  dynamic "headers" {
                    for_each = field_to_match.value.headers != null ? [field_to_match.value.headers] : []
                    content {
                      match_scope       = headers.value.match_scope
                      oversize_handling = headers.value.oversize_handling

                      dynamic "match_pattern" {
                        for_each = headers.value.match_pattern != null ? [headers.value.match_pattern] : []
                        content {
                          dynamic "all" {
                            for_each = match_pattern.value.all != null ? [match_pattern.value.all] : []
                            content {}
                          }
                          included_headers = match_pattern.value.included_headers
                          excluded_headers = match_pattern.value.excluded_headers
                        }
                      }
                    }
                  }
                  dynamic "header_order" {
                    for_each = field_to_match.value.header_order != null ? [field_to_match.value.header_order] : []
                    content {
                      oversize_handling = header_order.value.oversize_handling
                    }
                  }
                  dynamic "ja3_fingerprint" {
                    for_each = field_to_match.value.ja3_fingerprint != null ? [field_to_match.value.ja3_fingerprint] : []
                    content {
                      fallback_behavior = ja3_fingerprint.value.fallback_behavior
                    }
                  }
                  dynamic "ja4_fingerprint" {
                    for_each = field_to_match.value.ja4_fingerprint != null ? [field_to_match.value.ja4_fingerprint] : []
                    content {
                      fallback_behavior = ja4_fingerprint.value.fallback_behavior
                    }
                  }
                  dynamic "json_body" {
                    for_each = field_to_match.value.json_body != null ? [field_to_match.value.json_body] : []
                    content {
                      invalid_fallback_behavior = json_body.value.invalid_fallback_behavior
                      match_scope               = json_body.value.match_scope
                      oversize_handling         = json_body.value.oversize_handling

                      dynamic "match_pattern" {
                        for_each = json_body.value.match_pattern != null ? [json_body.value.match_pattern] : []
                        content {
                          dynamic "all" {
                            for_each = match_pattern.value.all != null ? [match_pattern.value.all] : []
                            content {}
                          }
                          included_paths = match_pattern.value.included_paths
                        }
                      }
                    }
                  }
                }
              }

              dynamic "text_transformation" {
                for_each = xss_match_statement.value.text_transformation
                content {
                  priority = text_transformation.value.priority
                  type     = text_transformation.value.type
                }
              }
            }
          }
        }
      }

      dynamic "visibility_config" {
        for_each = rule.value.visibility_config != null ? [rule.value.visibility_config] : []
        content {
          cloudwatch_metrics_enabled = visibility_config.value.cloudwatch_metrics_enabled
          metric_name                = visibility_config.value.metric_name
          sampled_requests_enabled   = visibility_config.value.sampled_requests_enabled
        }
      }
    }
  }

  dynamic "visibility_config" {
    for_each = var.visibility_config != null ? [var.visibility_config] : []
    content {
      cloudwatch_metrics_enabled = visibility_config.value.cloudwatch_metrics_enabled
      metric_name                = visibility_config.value.metric_name
      sampled_requests_enabled   = visibility_config.value.sampled_requests_enabled
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

}