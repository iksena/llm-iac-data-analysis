data "aws_bedrock_inference_profile" "this" {
  region               = var.region
  inference_profile_id = var.inference_profile_id
}