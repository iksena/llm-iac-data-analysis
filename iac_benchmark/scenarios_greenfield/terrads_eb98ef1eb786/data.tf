data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "sns_topic_policy" {
  version = "2012-10-17"

  statement {
    sid    = "AllowCloudWatchAlarmsToPublish"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }

    actions   = ["sns:Publish"]
    resources = ["*"]
  }
}
data "aws_iam_role" "execution_role" {
  name       = aws_iam_role.canary_execution_role.name
  depends_on = [aws_iam_role.canary_execution_role]
}
