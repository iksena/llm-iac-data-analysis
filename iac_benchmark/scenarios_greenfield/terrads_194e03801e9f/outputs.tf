output "webhook_url" {
    value = var.codestar_connection_arn != "" ? "" : aws_codepipeline_webhook.webhook.0.url
}