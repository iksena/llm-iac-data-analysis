data "aws_bedrock_foundation_model" "this" {
  model_id = var.model_id
  region   = var.region
}