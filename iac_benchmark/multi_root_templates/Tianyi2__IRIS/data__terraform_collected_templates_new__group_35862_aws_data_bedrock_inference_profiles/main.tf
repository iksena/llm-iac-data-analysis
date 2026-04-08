data "aws_bedrock_inference_profiles" "this" {
  region = var.region
  type   = var.type
}