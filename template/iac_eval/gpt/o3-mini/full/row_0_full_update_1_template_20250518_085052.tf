Below is the description followed by the complete deployable Terraform HCL code.

Description:
We define a Route 53 hosted zone named "primary" and a CloudWatch Log Group called "aws_route53_example_com". We then create a CloudWatch Logs resource policy named "route53-query-logging-policy" that allows the Route 53 service (principal "route53.amazonaws.com") to create log streams and put log events into the specified log group. Finally, we configure a Route 53 query log that directs query logs for the hosted zone to the CloudWatch log group. All required resources and variables (including a provider with a default region and a variable for the region) are declared so that the configuration is fully deployable.

<iac_template>
provider "aws" {
  region = var.region
}

variable "region" {
  type    = string
  default = "us-east-1"
}

resource "aws_route53_zone" "primary" {
  name = "primary"
}

resource "aws_cloudwatch_log_group" "aws_route53_example_com" {
  name = "aws_route53_example_com"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "route53_log_policy_doc" {
  statement {
    sid    = "Route53CreateLogStreamAndPutLogEvents"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    principals {
      type        = "Service"
      identifiers = ["route53.amazonaws.com"]
    }
    resources = [
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.aws_route53_example_com.name}:*"
    ]
  }
}

resource "aws_cloudwatch_log_resource_policy" "route53_query_logging_policy" {
  policy_name     = "route53-query-logging-policy"
  policy_document = data.aws_iam_policy_document.route53_log_policy_doc.json
}

resource "aws_route53_query_log" "query_log" {
  cloudwatch_log_group_arn = aws_cloudwatch_log_group.aws_route53_example_com.arn
  hosted_zone_id           = aws_route53_zone.primary.zone_id
}
</iac_template>