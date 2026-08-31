locals {
  event_rule_name = "${var.resource_prefix}-${terraform.workspace}-event-rule"
}

resource "aws_cloudwatch_event_rule" "kscope_crawler_rule" {
  name        = local.event_rule_name
  description = "Filters events from cloudtrail to an SQS Queue"
  event_pattern = jsonencode({
    "detail-type" : ["AWS API Call via CloudTrail"]
  })
}

resource "aws_cloudwatch_event_target" "kscope_event_target" {
  arn  = aws_sqs_queue.sqs-queue.arn
  rule = local.event_rule_name
}
