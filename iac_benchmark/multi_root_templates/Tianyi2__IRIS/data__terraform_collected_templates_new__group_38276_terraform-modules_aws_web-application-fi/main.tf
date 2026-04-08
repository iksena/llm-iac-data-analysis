##########################
#     Naming Config      #
##########################
module "resource_name_prefix" {
  source = "git@github.com:UKHSA-Internal/devops-terraform-modules.git//terraform-modules/helpers/resource-name-prefix?ref=TF/helpers/resource-name-prefix/vALPHA_0.0.2"

  name = var.name
  tags = var.tags
}

############################
# Web Application Firewall #
############################
resource "aws_wafv2_web_acl" "waf" {
  name        = "${module.resource_name_prefix.resource_name}-waf"
  scope       = var.scope
  description = "${module.resource_name_prefix.resource_name} WAF - ${var.waf_description}"

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${module.resource_name_prefix.resource_name}-WAF"
    sampled_requests_enabled   = var.sampled_requests_enabled
  }

  default_action {
    allow {}
  }

  ##########################
  # Common Threat Rule Set #
  ##########################
  rule {
    name     = "${module.resource_name_prefix.resource_name}-AWSManagedRulesCommonRuleSet"
    priority = 0

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${module.resource_name_prefix.resource_name}-AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = var.sampled_requests_enabled
    }
  }

  ##########################
  # SQL Injection Rule Set #
  ##########################
  rule {
    name     = "${module.resource_name_prefix.resource_name}-AWSManagedRulesSQLiRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${module.resource_name_prefix.resource_name}-AWSManagedSQLiRuleSet"
      sampled_requests_enabled   = var.sampled_requests_enabled
    }
  }

  tags = var.tags
}

##########################
# WAF Association to API #
##########################
resource "aws_wafv2_web_acl_association" "waf_association" {
  count        = length(var.association_resource_arns)
  resource_arn = var.association_resource_arns[count.index]
  web_acl_arn  = aws_wafv2_web_acl.waf.arn
}

##########################
#       Logging          #
##########################
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "aws-waf-logs-${module.resource_name_prefix.resource_name}" # the aws-waf-logs- is necessary for this config to work
  retention_in_days = var.retention_in_days
}

resource "aws_wafv2_web_acl_logging_configuration" "waf_logging_config" {
  log_destination_configs = [aws_cloudwatch_log_group.log_group.arn]
  resource_arn            = aws_wafv2_web_acl.waf.arn
}

resource "aws_cloudwatch_log_resource_policy" "resource_policy" {
  policy_document = data.aws_iam_policy_document.waf_cloudwatch_policy.json
  policy_name     = "${module.resource_name_prefix.resource_name}-waf-log-policy"
}

data "aws_caller_identity" "current" {}
data "aws_iam_policy_document" "waf_cloudwatch_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.log_group.arn}:*"]
    condition {
      test     = "ArnLike"
      values   = ["arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"]
      variable = "aws:SourceArn"
    }
    condition {
      test     = "StringEquals"
      values   = [tostring(data.aws_caller_identity.current.account_id)]
      variable = "aws:SourceAccount"
    }
  }
}
