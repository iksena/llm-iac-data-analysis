resource "aws_sns_topic_data_protection_policy" "this" {
  region = var.region
  arn    = var.arn
  policy = var.policy
}