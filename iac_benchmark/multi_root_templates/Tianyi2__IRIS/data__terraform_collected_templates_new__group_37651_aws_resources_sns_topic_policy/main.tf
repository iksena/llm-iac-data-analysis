resource "aws_sns_topic_policy" "this" {
  arn    = var.arn
  policy = var.policy
  region = var.region
}