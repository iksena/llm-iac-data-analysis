resource "aws_transcribe_language_model" "this" {
  region          = var.region
  base_model_name = var.base_model_name
  language_code   = var.language_code
  model_name      = var.model_name

  input_data_config {
    data_access_role_arn = var.input_data_config.data_access_role_arn
    s3_uri               = var.input_data_config.s3_uri
    tuning_data_s3_uri   = var.input_data_config.tuning_data_s3_uri
  }

  tags = var.tags

  timeouts {
    create = var.timeouts.create
  }
}