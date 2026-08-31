resource "aws_wafv2_ip_set" "trusted" {
  count              = var.trusted_ips == "" ? 0 : 1
  name               = "${var.project}-${var.function}-${var.environment}-whitelist"
  addresses          = var.trusted_ips
  ip_address_version = "IPV4"
  scope              = "REGIONAL"
}

resource "aws_wafv2_rule_group" "rule_group" {
  capacity = 12
  name     = "waf-rule-group"
  scope    = "REGIONAL"
  rule {
    name     = "waf-rule-restricted-uri"
    priority = 20
    action {
      block {}
    }
    statement {
      and_statement {
        statement {
          byte_match_statement {
            positional_constraint = "CONTAINS"
            search_string         = var.restricted_uri
            field_to_match {
              uri_path {}
            }
            text_transformation {
              priority = 10
              type     = "NONE"
            }
          }
        }
        statement {
          not_statement {
            statement {
              ip_set_reference_statement {
                arn = aws_wafv2_ip_set.trusted[0].arn
              }
            }
          }
        }
      }

    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "url-restrictions"
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "geo-match-restrictions"
    priority = 30
    action {
      allow {}
    }
    statement {
      geo_match_statement {
        country_codes = var.environment == "intg" || var.environment == "staging" ? ["GB", "US", "DE"] : ["GB"]
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "waf-geo-match"
      sampled_requests_enabled   = false
    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "geo-match-metric"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl" "acl" {
  name  = "${var.project}-${var.function}-${var.environment}-restricted-uri"
  scope = "REGIONAL"
  default_action {
    block {}
  }
  rule {

    name     = "rate-based-rule"
    priority = 0
    action {
      block {}
    }
    statement {
      rate_based_statement {
        limit = 15000
        scope_down_statement {
          not_statement {
            statement {
              ip_set_reference_statement {
                arn = aws_wafv2_ip_set.trusted[0].arn
              }
            }
          }
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "acl-rule-metric"
      sampled_requests_enabled   = false
    }
  }
  rule {
    name     = "acl-rule"
    priority = 1
    override_action {
      none {}
    }
    statement {
      rule_group_reference_statement {
        arn = aws_wafv2_rule_group.rule_group.arn
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "acl-rule-metric"
      sampled_requests_enabled   = false
    }
  }

  dynamic "rule" {
    for_each = toset(var.aws_managed_rules)
    content {
      name     = rule.value.name
      priority = rule.value.priority
      override_action {
        none {}
      }
      statement {
        managed_rule_group_statement {
          name        = rule.value.managed_rule_group_statement_name
          vendor_name = rule.value.managed_rule_group_statement_vendor_name
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = false
        metric_name                = rule.value.metric_name
        sampled_requests_enabled   = false
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "restricted-uri"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_association" "association" {
  count        = length(var.alb_target_groups)
  resource_arn = var.alb_target_groups[count.index]
  web_acl_arn  = aws_wafv2_web_acl.acl.arn
}

resource "aws_wafv2_web_acl_logging_configuration" "waf_logging" {
  log_destination_configs = var.log_destinations
  resource_arn            = aws_wafv2_web_acl.acl.arn
}
