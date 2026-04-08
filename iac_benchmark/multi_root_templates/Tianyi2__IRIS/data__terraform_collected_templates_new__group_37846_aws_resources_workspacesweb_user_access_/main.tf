resource "aws_workspacesweb_user_access_logging_settings" "this" {
  kinesis_stream_arn = var.kinesis_stream_arn
  region             = var.region
  tags               = var.tags
}