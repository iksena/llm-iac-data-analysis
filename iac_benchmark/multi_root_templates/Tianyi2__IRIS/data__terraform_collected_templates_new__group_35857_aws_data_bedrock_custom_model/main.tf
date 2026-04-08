data "aws_bedrock_custom_model" "this" {
  model_id = var.model_id
  region   = var.region
}