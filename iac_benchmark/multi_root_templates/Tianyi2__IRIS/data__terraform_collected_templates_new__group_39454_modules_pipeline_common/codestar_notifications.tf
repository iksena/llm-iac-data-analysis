resource "aws_codestarnotifications_notification_rule" "failed_codepipeline" {
  detail_type = "FULL"
  event_type_ids = [
    "codepipeline-pipeline-pipeline-execution-failed"
  ]

  name     = local.pipeline_name
  resource = "arn:aws:codepipeline:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:${local.pipeline_name}"

  target {
    address = var.sns_topic_arn
  }

  tags = var.tags
}
