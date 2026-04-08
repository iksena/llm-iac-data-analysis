variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "capacity" {
  description = "The web ACL capacity units (WCUs) required for this rule group."
  type        = number

  validation {
    condition     = var.capacity > 0
    error_message = "resource_aws_wafv2_rule_group, capacity must be greater than 0."
  }
}

variable "custom_response_body" {
  description = "Defines custom response bodies that can be referenced by custom_response actions."
  type = list(object({
    key          = string
    content      = string
    content_type = string
  }))
  default = []

  validation {
    condition = alltrue([
      for crb in var.custom_response_body :
      contains(["TEXT_PLAIN", "TEXT_HTML", "APPLICATION_JSON"], crb.content_type)
    ])
    error_message = "resource_aws_wafv2_rule_group, custom_response_body content_type must be one of: TEXT_PLAIN, TEXT_HTML, APPLICATION_JSON."
  }
}

variable "description" {
  description = "A friendly description of the rule group."
  type        = string
  default     = null
}

variable "name" {
  description = "A friendly name of the rule group."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || can(regex("^[a-zA-Z0-9_-]+$", var.name))
    error_message = "resource_aws_wafv2_rule_group, name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null

  validation {
    condition     = var.name_prefix == null || can(regex("^[a-zA-Z0-9_-]+$", var.name_prefix))
    error_message = "resource_aws_wafv2_rule_group, name_prefix must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "rule" {
  description = "The rule blocks used to identify the web requests that you want to allow, block, or count."
  type = list(object({
    name     = string
    priority = number
    action = optional(object({
      allow = optional(object({
        custom_request_handling = optional(object({
          insert_header = list(object({
            name  = string
            value = string
          }))
        }))
      }))
      block = optional(object({
        custom_response = optional(object({
          custom_response_body_key = optional(string)
          response_code            = number
          response_header = optional(list(object({
            name  = string
            value = string
          })), [])
        }))
      }))
      captcha = optional(object({
        custom_request_handling = optional(object({
          insert_header = list(object({
            name  = string
            value = string
          }))
        }))
      }))
      challenge = optional(object({
        custom_request_handling = optional(object({
          insert_header = list(object({
            name  = string
            value = string
          }))
        }))
      }))
      count = optional(object({
        custom_request_handling = optional(object({
          insert_header = list(object({
            name  = string
            value = string
          }))
        }))
      }))
    }))
    captcha_config = optional(object({
      immunity_time_property = optional(object({
        immunity_time = optional(number)
      }))
    }))
    rule_label = optional(list(object({
      name = string
    })), [])
    statement = optional(object({
      and_statement = optional(object({
        statement = list(object({
          byte_match_statement = optional(object({
            positional_constraint = string
            search_string         = string
            field_to_match = optional(object({
              all_query_arguments = optional(object({}))
              body                = optional(object({}))
              method              = optional(object({}))
              query_string        = optional(object({}))
              uri_path            = optional(object({}))
              single_header = optional(object({
                name = string
              }))
              single_query_argument = optional(object({
                name = string
              }))
              uri_fragment = optional(object({
                fallback_behavior = optional(string)
              }))
              cookies = optional(object({
                match_scope       = string
                oversize_handling = string
                match_pattern = optional(object({
                  all              = optional(object({}))
                  included_cookies = optional(list(string))
                  excluded_cookies = optional(list(string))
                }))
              }))
              headers = optional(object({
                match_scope       = string
                oversize_handling = string
                match_pattern = optional(object({
                  all              = optional(object({}))
                  included_headers = optional(list(string))
                  excluded_headers = optional(list(string))
                }))
              }))
              header_order = optional(object({
                oversize_handling = string
              }))
              ja3_fingerprint = optional(object({
                fallback_behavior = string
              }))
              ja4_fingerprint = optional(object({
                fallback_behavior = string
              }))
              json_body = optional(object({
                invalid_fallback_behavior = optional(string)
                match_scope               = string
                oversize_handling         = optional(string)
                match_pattern = optional(object({
                  all            = optional(object({}))
                  included_paths = optional(list(string))
                }))
              }))
            }))
            text_transformation = list(object({
              priority = number
              type     = string
            }))
          }))
          geo_match_statement = optional(object({
            country_codes = list(string)
            forwarded_ip_config = optional(object({
              fallback_behavior = string
              header_name       = string
            }))
          }))
          # Additional statement types would be defined here in full implementation
        }))
      }))
      or_statement = optional(object({
        statement = list(object({
          regex_match_statement = optional(object({
            regex_string = string
            field_to_match = optional(object({
              all_query_arguments = optional(object({}))
              body                = optional(object({}))
              method              = optional(object({}))
              query_string        = optional(object({}))
              uri_path            = optional(object({}))
              single_header = optional(object({
                name = string
              }))
              single_query_argument = optional(object({
                name = string
              }))
              uri_fragment = optional(object({
                fallback_behavior = optional(string)
              }))
              cookies = optional(object({
                match_scope       = string
                oversize_handling = string
                match_pattern = optional(object({
                  all              = optional(object({}))
                  included_cookies = optional(list(string))
                  excluded_cookies = optional(list(string))
                }))
              }))
              headers = optional(object({
                match_scope       = string
                oversize_handling = string
                match_pattern = optional(object({
                  all              = optional(object({}))
                  included_headers = optional(list(string))
                  excluded_headers = optional(list(string))
                }))
              }))
              header_order = optional(object({
                oversize_handling = string
              }))
              ja3_fingerprint = optional(object({
                fallback_behavior = string
              }))
              ja4_fingerprint = optional(object({
                fallback_behavior = string
              }))
              json_body = optional(object({
                invalid_fallback_behavior = optional(string)
                match_scope               = string
                oversize_handling         = optional(string)
                match_pattern = optional(object({
                  all            = optional(object({}))
                  included_paths = optional(list(string))
                }))
              }))
            }))
            text_transformation = list(object({
              priority = number
              type     = string
            }))
          }))
          sqli_match_statement = optional(object({
            sensitivity_level = optional(string)
            field_to_match = optional(object({
              all_query_arguments = optional(object({}))
              body                = optional(object({}))
              method              = optional(object({}))
              query_string        = optional(object({}))
              uri_path            = optional(object({}))
              single_header = optional(object({
                name = string
              }))
              single_query_argument = optional(object({
                name = string
              }))
              uri_fragment = optional(object({
                fallback_behavior = optional(string)
              }))
              cookies = optional(object({
                match_scope       = string
                oversize_handling = string
                match_pattern = optional(object({
                  all              = optional(object({}))
                  included_cookies = optional(list(string))
                  excluded_cookies = optional(list(string))
                }))
              }))
              headers = optional(object({
                match_scope       = string
                oversize_handling = string
                match_pattern = optional(object({
                  all              = optional(object({}))
                  included_headers = optional(list(string))
                  excluded_headers = optional(list(string))
                }))
              }))
              header_order = optional(object({
                oversize_handling = string
              }))
              ja3_fingerprint = optional(object({
                fallback_behavior = string
              }))
              ja4_fingerprint = optional(object({
                fallback_behavior = string
              }))
              json_body = optional(object({
                invalid_fallback_behavior = optional(string)
                match_scope               = string
                oversize_handling         = optional(string)
                match_pattern = optional(object({
                  all            = optional(object({}))
                  included_paths = optional(list(string))
                }))
              }))
            }))
            text_transformation = list(object({
              priority = number
              type     = string
            }))
          }))
          xss_match_statement = optional(object({
            field_to_match = optional(object({
              all_query_arguments = optional(object({}))
              body                = optional(object({}))
              method              = optional(object({}))
              query_string        = optional(object({}))
              uri_path            = optional(object({}))
              single_header = optional(object({
                name = string
              }))
              single_query_argument = optional(object({
                name = string
              }))
              uri_fragment = optional(object({
                fallback_behavior = optional(string)
              }))
              cookies = optional(object({
                match_scope       = string
                oversize_handling = string
                match_pattern = optional(object({
                  all              = optional(object({}))
                  included_cookies = optional(list(string))
                  excluded_cookies = optional(list(string))
                }))
              }))
              headers = optional(object({
                match_scope       = string
                oversize_handling = string
                match_pattern = optional(object({
                  all              = optional(object({}))
                  included_headers = optional(list(string))
                  excluded_headers = optional(list(string))
                }))
              }))
              header_order = optional(object({
                oversize_handling = string
              }))
              ja3_fingerprint = optional(object({
                fallback_behavior = string
              }))
              ja4_fingerprint = optional(object({
                fallback_behavior = string
              }))
              json_body = optional(object({
                invalid_fallback_behavior = optional(string)
                match_scope               = string
                oversize_handling         = optional(string)
                match_pattern = optional(object({
                  all            = optional(object({}))
                  included_paths = optional(list(string))
                }))
              }))
            }))
            text_transformation = list(object({
              priority = number
              type     = string
            }))
          }))
          ip_set_reference_statement = optional(object({
            arn = string
            ip_set_forwarded_ip_config = optional(object({
              fallback_behavior = string
              header_name       = string
              position          = string
            }))
          }))
          regex_pattern_set_reference_statement = optional(object({
            arn = string
            field_to_match = optional(object({
              all_query_arguments = optional(object({}))
              body                = optional(object({}))
              method              = optional(object({}))
              query_string        = optional(object({}))
              uri_path            = optional(object({}))
              single_header = optional(object({
                name = string
              }))
              single_query_argument = optional(object({
                name = string
              }))
              uri_fragment = optional(object({
                fallback_behavior = optional(string)
              }))
              cookies = optional(object({
                match_scope       = string
                oversize_handling = string
                match_pattern = optional(object({
                  all              = optional(object({}))
                  included_cookies = optional(list(string))
                  excluded_cookies = optional(list(string))
                }))
              }))
              headers = optional(object({
                match_scope       = string
                oversize_handling = string
                match_pattern = optional(object({
                  all              = optional(object({}))
                  included_headers = optional(list(string))
                  excluded_headers = optional(list(string))
                }))
              }))
              header_order = optional(object({
                oversize_handling = string
              }))
              ja3_fingerprint = optional(object({
                fallback_behavior = string
              }))
              ja4_fingerprint = optional(object({
                fallback_behavior = string
              }))
              json_body = optional(object({
                invalid_fallback_behavior = optional(string)
                match_scope               = string
                oversize_handling         = optional(string)
                match_pattern = optional(object({
                  all            = optional(object({}))
                  included_paths = optional(list(string))
                }))
              }))
            }))
            text_transformation = list(object({
              priority = number
              type     = string
            }))
          }))
        }))
      }))
      not_statement = optional(object({
        statement = optional(object({
          and_statement = optional(object({
            statement = list(object({
              byte_match_statement = optional(object({
                positional_constraint = string
                search_string         = string
                field_to_match = optional(object({
                  all_query_arguments = optional(object({}))
                  body                = optional(object({}))
                  method              = optional(object({}))
                  query_string        = optional(object({}))
                  uri_path            = optional(object({}))
                  single_header = optional(object({
                    name = string
                  }))
                  single_query_argument = optional(object({
                    name = string
                  }))
                  uri_fragment = optional(object({
                    fallback_behavior = optional(string)
                  }))
                  cookies = optional(object({
                    match_scope       = string
                    oversize_handling = string
                    match_pattern = optional(object({
                      all              = optional(object({}))
                      included_cookies = optional(list(string))
                      excluded_cookies = optional(list(string))
                    }))
                  }))
                  headers = optional(object({
                    match_scope       = string
                    oversize_handling = string
                    match_pattern = optional(object({
                      all              = optional(object({}))
                      included_headers = optional(list(string))
                      excluded_headers = optional(list(string))
                    }))
                  }))
                  header_order = optional(object({
                    oversize_handling = string
                  }))
                  ja3_fingerprint = optional(object({
                    fallback_behavior = string
                  }))
                  ja4_fingerprint = optional(object({
                    fallback_behavior = string
                  }))
                  json_body = optional(object({
                    invalid_fallback_behavior = optional(string)
                    match_scope               = string
                    oversize_handling         = optional(string)
                    match_pattern = optional(object({
                      all            = optional(object({}))
                      included_paths = optional(list(string))
                    }))
                  }))
                }))
                text_transformation = list(object({
                  priority = number
                  type     = string
                }))
              }))
              geo_match_statement = optional(object({
                country_codes = list(string)
                forwarded_ip_config = optional(object({
                  fallback_behavior = string
                  header_name       = string
                }))
              }))
            }))
          }))
        }))
      }))
      size_constraint_statement = optional(object({
        comparison_operator = string
        size                = number
        field_to_match = optional(object({
          all_query_arguments = optional(object({}))
          body                = optional(object({}))
          method              = optional(object({}))
          query_string        = optional(object({}))
          uri_path            = optional(object({}))
          single_header = optional(object({
            name = string
          }))
          single_query_argument = optional(object({
            name = string
          }))
          uri_fragment = optional(object({
            fallback_behavior = optional(string)
          }))
          cookies = optional(object({
            match_scope       = string
            oversize_handling = string
            match_pattern = optional(object({
              all              = optional(object({}))
              included_cookies = optional(list(string))
              excluded_cookies = optional(list(string))
            }))
          }))
          headers = optional(object({
            match_scope       = string
            oversize_handling = string
            match_pattern = optional(object({
              all              = optional(object({}))
              included_headers = optional(list(string))
              excluded_headers = optional(list(string))
            }))
          }))
          header_order = optional(object({
            oversize_handling = string
          }))
          ja3_fingerprint = optional(object({
            fallback_behavior = string
          }))
          ja4_fingerprint = optional(object({
            fallback_behavior = string
          }))
          json_body = optional(object({
            invalid_fallback_behavior = optional(string)
            match_scope               = string
            oversize_handling         = optional(string)
            match_pattern = optional(object({
              all            = optional(object({}))
              included_paths = optional(list(string))
            }))
          }))
        }))
        text_transformation = list(object({
          priority = number
          type     = string
        }))
      }))
      rate_based_statement = optional(object({
        aggregate_key_type    = optional(string)
        evaluation_window_sec = optional(number)
        limit                 = number
        custom_key = optional(list(object({
          cookie = optional(object({
            name = string
            text_transformation = list(object({
              priority = number
              type     = string
            }))
          }))
          forwarded_ip = optional(object({}))
          header = optional(object({
            name = string
            text_transformation = list(object({
              priority = number
              type     = string
            }))
          }))
          http_method = optional(object({}))
          ip          = optional(object({}))
          ja3_fingerprint = optional(object({
            fallback_behavior = string
          }))
          ja4_fingerprint = optional(object({
            fallback_behavior = string
          }))
          label_namespace = optional(object({
            namespace = string
          }))
          query_argument = optional(object({
            name = string
            text_transformation = list(object({
              priority = number
              type     = string
            }))
          }))
          query_string = optional(object({
            text_transformation = list(object({
              priority = number
              type     = string
            }))
          }))
          uri_path = optional(object({
            text_transformation = list(object({
              priority = number
              type     = string
            }))
          }))
        })), [])
        forwarded_ip_config = optional(object({
          fallback_behavior = string
          header_name       = string
        }))
        scope_down_statement = optional(object({
          byte_match_statement = optional(object({
            positional_constraint = string
            search_string         = string
            field_to_match = optional(object({
              all_query_arguments = optional(object({}))
              body                = optional(object({}))
              method              = optional(object({}))
              query_string        = optional(object({}))
              uri_path            = optional(object({}))
              single_header = optional(object({
                name = string
              }))
              single_query_argument = optional(object({
                name = string
              }))
              uri_fragment = optional(object({
                fallback_behavior = optional(string)
              }))
              cookies = optional(object({
                match_scope       = string
                oversize_handling = string
                match_pattern = optional(object({
                  all              = optional(object({}))
                  included_cookies = optional(list(string))
                  excluded_cookies = optional(list(string))
                }))
              }))
              headers = optional(object({
                match_scope       = string
                oversize_handling = string
                match_pattern = optional(object({
                  all              = optional(object({}))
                  included_headers = optional(list(string))
                  excluded_headers = optional(list(string))
                }))
              }))
              header_order = optional(object({
                oversize_handling = string
              }))
              ja3_fingerprint = optional(object({
                fallback_behavior = string
              }))
              ja4_fingerprint = optional(object({
                fallback_behavior = string
              }))
              json_body = optional(object({
                invalid_fallback_behavior = optional(string)
                match_scope               = string
                oversize_handling         = optional(string)
                match_pattern = optional(object({
                  all            = optional(object({}))
                  included_paths = optional(list(string))
                }))
              }))
            }))
            text_transformation = list(object({
              priority = number
              type     = string
            }))
          }))
        }))
      }))
      asn_match_statement = optional(object({
        asn_list = list(number)
        forwarded_ip_config = optional(object({
          fallback_behavior = string
          header_name       = string
        }))
      }))
      label_match_statement = optional(object({
        scope = string
        key   = string
      }))
      byte_match_statement = optional(object({
        positional_constraint = string
        search_string         = string
        field_to_match = optional(object({
          all_query_arguments = optional(object({}))
          body                = optional(object({}))
          method              = optional(object({}))
          query_string        = optional(object({}))
          uri_path            = optional(object({}))
          single_header = optional(object({
            name = string
          }))
          single_query_argument = optional(object({
            name = string
          }))
          uri_fragment = optional(object({
            fallback_behavior = optional(string)
          }))
          cookies = optional(object({
            match_scope       = string
            oversize_handling = string
            match_pattern = optional(object({
              all              = optional(object({}))
              included_cookies = optional(list(string))
              excluded_cookies = optional(list(string))
            }))
          }))
          headers = optional(object({
            match_scope       = string
            oversize_handling = string
            match_pattern = optional(object({
              all              = optional(object({}))
              included_headers = optional(list(string))
              excluded_headers = optional(list(string))
            }))
          }))
          header_order = optional(object({
            oversize_handling = string
          }))
          ja3_fingerprint = optional(object({
            fallback_behavior = string
          }))
          ja4_fingerprint = optional(object({
            fallback_behavior = string
          }))
          json_body = optional(object({
            invalid_fallback_behavior = optional(string)
            match_scope               = string
            oversize_handling         = optional(string)
            match_pattern = optional(object({
              all            = optional(object({}))
              included_paths = optional(list(string))
            }))
          }))
        }))
        text_transformation = list(object({
          priority = number
          type     = string
        }))
      }))
      geo_match_statement = optional(object({
        country_codes = list(string)
        forwarded_ip_config = optional(object({
          fallback_behavior = string
          header_name       = string
        }))
      }))
      ip_set_reference_statement = optional(object({
        arn = string
        ip_set_forwarded_ip_config = optional(object({
          fallback_behavior = string
          header_name       = string
          position          = string
        }))
      }))
      regex_match_statement = optional(object({
        regex_string = string
        field_to_match = optional(object({
          all_query_arguments = optional(object({}))
          body                = optional(object({}))
          method              = optional(object({}))
          query_string        = optional(object({}))
          uri_path            = optional(object({}))
          single_header = optional(object({
            name = string
          }))
          single_query_argument = optional(object({
            name = string
          }))
          uri_fragment = optional(object({
            fallback_behavior = optional(string)
          }))
          cookies = optional(object({
            match_scope       = string
            oversize_handling = string
            match_pattern = optional(object({
              all              = optional(object({}))
              included_cookies = optional(list(string))
              excluded_cookies = optional(list(string))
            }))
          }))
          headers = optional(object({
            match_scope       = string
            oversize_handling = string
            match_pattern = optional(object({
              all              = optional(object({}))
              included_headers = optional(list(string))
              excluded_headers = optional(list(string))
            }))
          }))
          header_order = optional(object({
            oversize_handling = string
          }))
          ja3_fingerprint = optional(object({
            fallback_behavior = string
          }))
          ja4_fingerprint = optional(object({
            fallback_behavior = string
          }))
          json_body = optional(object({
            invalid_fallback_behavior = optional(string)
            match_scope               = string
            oversize_handling         = optional(string)
            match_pattern = optional(object({
              all            = optional(object({}))
              included_paths = optional(list(string))
            }))
          }))
        }))
        text_transformation = list(object({
          priority = number
          type     = string
        }))
      }))
      regex_pattern_set_reference_statement = optional(object({
        arn = string
        field_to_match = optional(object({
          all_query_arguments = optional(object({}))
          body                = optional(object({}))
          method              = optional(object({}))
          query_string        = optional(object({}))
          uri_path            = optional(object({}))
          single_header = optional(object({
            name = string
          }))
          single_query_argument = optional(object({
            name = string
          }))
          uri_fragment = optional(object({
            fallback_behavior = optional(string)
          }))
          cookies = optional(object({
            match_scope       = string
            oversize_handling = string
            match_pattern = optional(object({
              all              = optional(object({}))
              included_cookies = optional(list(string))
              excluded_cookies = optional(list(string))
            }))
          }))
          headers = optional(object({
            match_scope       = string
            oversize_handling = string
            match_pattern = optional(object({
              all              = optional(object({}))
              included_headers = optional(list(string))
              excluded_headers = optional(list(string))
            }))
          }))
          header_order = optional(object({
            oversize_handling = string
          }))
          ja3_fingerprint = optional(object({
            fallback_behavior = string
          }))
          ja4_fingerprint = optional(object({
            fallback_behavior = string
          }))
          json_body = optional(object({
            invalid_fallback_behavior = optional(string)
            match_scope               = string
            oversize_handling         = optional(string)
            match_pattern = optional(object({
              all            = optional(object({}))
              included_paths = optional(list(string))
            }))
          }))
        }))
        text_transformation = list(object({
          priority = number
          type     = string
        }))
      }))
      sqli_match_statement = optional(object({
        sensitivity_level = optional(string)
        field_to_match = optional(object({
          all_query_arguments = optional(object({}))
          body                = optional(object({}))
          method              = optional(object({}))
          query_string        = optional(object({}))
          uri_path            = optional(object({}))
          single_header = optional(object({
            name = string
          }))
          single_query_argument = optional(object({
            name = string
          }))
          uri_fragment = optional(object({
            fallback_behavior = optional(string)
          }))
          cookies = optional(object({
            match_scope       = string
            oversize_handling = string
            match_pattern = optional(object({
              all              = optional(object({}))
              included_cookies = optional(list(string))
              excluded_cookies = optional(list(string))
            }))
          }))
          headers = optional(object({
            match_scope       = string
            oversize_handling = string
            match_pattern = optional(object({
              all              = optional(object({}))
              included_headers = optional(list(string))
              excluded_headers = optional(list(string))
            }))
          }))
          header_order = optional(object({
            oversize_handling = string
          }))
          ja3_fingerprint = optional(object({
            fallback_behavior = string
          }))
          ja4_fingerprint = optional(object({
            fallback_behavior = string
          }))
          json_body = optional(object({
            invalid_fallback_behavior = optional(string)
            match_scope               = string
            oversize_handling         = optional(string)
            match_pattern = optional(object({
              all            = optional(object({}))
              included_paths = optional(list(string))
            }))
          }))
        }))
        text_transformation = list(object({
          priority = number
          type     = string
        }))
      }))
      xss_match_statement = optional(object({
        field_to_match = optional(object({
          all_query_arguments = optional(object({}))
          body                = optional(object({}))
          method              = optional(object({}))
          query_string        = optional(object({}))
          uri_path            = optional(object({}))
          single_header = optional(object({
            name = string
          }))
          single_query_argument = optional(object({
            name = string
          }))
          uri_fragment = optional(object({
            fallback_behavior = optional(string)
          }))
          cookies = optional(object({
            match_scope       = string
            oversize_handling = string
            match_pattern = optional(object({
              all              = optional(object({}))
              included_cookies = optional(list(string))
              excluded_cookies = optional(list(string))
            }))
          }))
          headers = optional(object({
            match_scope       = string
            oversize_handling = string
            match_pattern = optional(object({
              all              = optional(object({}))
              included_headers = optional(list(string))
              excluded_headers = optional(list(string))
            }))
          }))
          header_order = optional(object({
            oversize_handling = string
          }))
          ja3_fingerprint = optional(object({
            fallback_behavior = string
          }))
          ja4_fingerprint = optional(object({
            fallback_behavior = string
          }))
          json_body = optional(object({
            invalid_fallback_behavior = optional(string)
            match_scope               = string
            oversize_handling         = optional(string)
            match_pattern = optional(object({
              all            = optional(object({}))
              included_paths = optional(list(string))
            }))
          }))
        }))
        text_transformation = list(object({
          priority = number
          type     = string
        }))
      }))
    }))
    visibility_config = optional(object({
      cloudwatch_metrics_enabled = bool
      metric_name                = string
      sampled_requests_enabled   = bool
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.rule :
      rule.name != null && rule.name != ""
    ])
    error_message = "resource_aws_wafv2_rule_group, rule name must be provided and non-empty."
  }

  validation {
    condition = alltrue([
      for rule in var.rule :
      rule.priority != null && rule.priority >= 0
    ])
    error_message = "resource_aws_wafv2_rule_group, rule priority must be provided and non-negative."
  }

  validation {
    condition = alltrue([
      for rule in var.rule :
      rule.visibility_config != null ? (
        can(regex("^[a-zA-Z0-9_-]+$", rule.visibility_config.metric_name)) &&
        length(rule.visibility_config.metric_name) >= 1 &&
        length(rule.visibility_config.metric_name) <= 128
      ) : true
    ])
    error_message = "resource_aws_wafv2_rule_group, rule visibility_config metric_name must contain only alphanumeric characters, hyphens, and underscores, and be 1-128 characters long."
  }

  # Validate positional constraints
  validation {
    condition = alltrue(flatten([
      for rule in var.rule : [
        for statement in(rule.statement != null ? [rule.statement] : []) : [
          for byte_match in(statement.byte_match_statement != null ? [statement.byte_match_statement] : []) :
          contains(["EXACTLY", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CONTAINS_WORD"], byte_match.positional_constraint)
        ]
      ]
    ]))
    error_message = "resource_aws_wafv2_rule_group, byte_match_statement positional_constraint must be one of: EXACTLY, STARTS_WITH, ENDS_WITH, CONTAINS, CONTAINS_WORD."
  }

  # Validate comparison operators
  validation {
    condition = alltrue(flatten([
      for rule in var.rule : [
        for statement in(rule.statement != null ? [rule.statement] : []) : [
          for size_constraint in(statement.size_constraint_statement != null ? [statement.size_constraint_statement] : []) :
          contains(["EQ", "NE", "LE", "LT", "GE", "GT"], size_constraint.comparison_operator)
        ]
      ]
    ]))
    error_message = "resource_aws_wafv2_rule_group, size_constraint_statement comparison_operator must be one of: EQ, NE, LE, LT, GE, GT."
  }

  # Validate fallback behaviors
  validation {
    condition = alltrue(flatten([
      for rule in var.rule : [
        for statement in(rule.statement != null ? [rule.statement] : []) : [
          for forwarded_ip in(statement.geo_match_statement != null && statement.geo_match_statement.forwarded_ip_config != null ? [statement.geo_match_statement.forwarded_ip_config] : []) :
          contains(["MATCH", "NO_MATCH"], forwarded_ip.fallback_behavior)
        ]
      ]
    ]))
    error_message = "resource_aws_wafv2_rule_group, forwarded_ip_config fallback_behavior must be MATCH or NO_MATCH."
  }

  # Validate oversize handling
  validation {
    condition = alltrue(flatten([
      for rule in var.rule : [
        for statement in(rule.statement != null ? [rule.statement] : []) : [
          for field_to_match in(statement.byte_match_statement != null && statement.byte_match_statement.field_to_match != null ? [statement.byte_match_statement.field_to_match] : []) : [
            for headers in(field_to_match.headers != null ? [field_to_match.headers] : []) :
            contains(["CONTINUE", "MATCH", "NO_MATCH"], headers.oversize_handling)
          ]
        ]
      ]
    ]))
    error_message = "resource_aws_wafv2_rule_group, headers oversize_handling must be one of: CONTINUE, MATCH, NO_MATCH."
  }

  # Validate match scope
  validation {
    condition = alltrue(flatten([
      for rule in var.rule : [
        for statement in(rule.statement != null ? [rule.statement] : []) : [
          for field_to_match in(statement.byte_match_statement != null && statement.byte_match_statement.field_to_match != null ? [statement.byte_match_statement.field_to_match] : []) : [
            for headers in(field_to_match.headers != null ? [field_to_match.headers] : []) :
            contains(["ALL", "KEY", "VALUE"], headers.match_scope) if headers.match_scope != null
          ]
        ]
      ]
    ]))
    error_message = "resource_aws_wafv2_rule_group, headers match_scope must be one of: ALL, KEY, VALUE."
  }

  # Validate sensitivity level
  validation {
    condition = alltrue(flatten([
      for rule in var.rule : [
        for statement in(rule.statement != null ? [rule.statement] : []) : [
          for sqli in(statement.sqli_match_statement != null ? [statement.sqli_match_statement] : []) :
          sqli.sensitivity_level == null || contains(["LOW", "HIGH"], sqli.sensitivity_level)
        ]
      ]
    ]))
    error_message = "resource_aws_wafv2_rule_group, sqli_match_statement sensitivity_level must be LOW or HIGH."
  }

  # Validate label match scope
  validation {
    condition = alltrue(flatten([
      for rule in var.rule : [
        for statement in(rule.statement != null ? [rule.statement] : []) : [
          for label_match in(statement.label_match_statement != null ? [statement.label_match_statement] : []) :
          contains(["LABEL", "NAMESPACE"], label_match.scope)
        ]
      ]
    ]))
    error_message = "resource_aws_wafv2_rule_group, label_match_statement scope must be LABEL or NAMESPACE."
  }

  # Validate aggregate key type
  validation {
    condition = alltrue(flatten([
      for rule in var.rule : [
        for statement in(rule.statement != null ? [rule.statement] : []) : [
          for rate_based in(statement.rate_based_statement != null ? [statement.rate_based_statement] : []) :
          rate_based.aggregate_key_type == null || contains(["CONSTANT", "CUSTOM_KEYS", "FORWARDED_IP", "IP"], rate_based.aggregate_key_type)
        ]
      ]
    ]))
    error_message = "resource_aws_wafv2_rule_group, rate_based_statement aggregate_key_type must be one of: CONSTANT, CUSTOM_KEYS, FORWARDED_IP, IP."
  }

  # Validate evaluation window
  validation {
    condition = alltrue(flatten([
      for rule in var.rule : [
        for statement in(rule.statement != null ? [rule.statement] : []) : [
          for rate_based in(statement.rate_based_statement != null ? [statement.rate_based_statement] : []) :
          rate_based.evaluation_window_sec == null || contains([60, 120, 300, 600], rate_based.evaluation_window_sec)
        ]
      ]
    ]))
    error_message = "resource_aws_wafv2_rule_group, rate_based_statement evaluation_window_sec must be one of: 60, 120, 300, 600."
  }
}

variable "rules_json" {
  description = "Raw JSON string to allow more than three nested statements. Conflicts with rule attribute."
  type        = string
  default     = null
}

variable "scope" {
  description = "Specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL."
  type        = string

  validation {
    condition     = contains(["CLOUDFRONT", "REGIONAL"], var.scope)
    error_message = "resource_aws_wafv2_rule_group, scope must be either CLOUDFRONT or REGIONAL."
  }
}

variable "tags" {
  description = "An array of key:value pairs to associate with the resource."
  type        = map(string)
  default     = {}
}

variable "visibility_config" {
  description = "Defines and enables Amazon CloudWatch metrics and web request sample collection."
  type = object({
    cloudwatch_metrics_enabled = bool
    metric_name                = string
    sampled_requests_enabled   = bool
  })

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.visibility_config.metric_name))
    error_message = "resource_aws_wafv2_rule_group, visibility_config metric_name must contain only alphanumeric characters, hyphens, and underscores."
  }

  validation {
    condition     = length(var.visibility_config.metric_name) >= 1 && length(var.visibility_config.metric_name) <= 128
    error_message = "resource_aws_wafv2_rule_group, visibility_config metric_name must be 1-128 characters long."
  }
}

variable "captcha_config" {
  description = "Specifies how AWS WAF should handle CAPTCHA evaluations."
  type = object({
    immunity_time_property = optional(object({
      immunity_time = optional(number)
    }))
  })
  default = null

  validation {
    condition = var.captcha_config == null || (
      var.captcha_config.immunity_time_property == null ||
      var.captcha_config.immunity_time_property.immunity_time == null ||
      var.captcha_config.immunity_time_property.immunity_time >= 60
    )
    error_message = "resource_aws_wafv2_rule_group, captcha_config immunity_time must be at least 60 seconds."
  }
}