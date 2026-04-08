data "aws_bedrock_foundation_models" "this" {
  region                = var.region
  by_customization_type = var.by_customization_type
  by_inference_type     = var.by_inference_type
  by_output_modality    = var.by_output_modality
  by_provider           = var.by_provider
}