resource "aws_bedrock_guardrail_version" "this" {
  guardrail_arn = var.guardrail_arn
  region        = var.region
  description   = var.description
  skip_destroy  = var.skip_destroy

  timeouts {
    create = "5m"
    delete = "5m"
  }
}