resource "aws_chimesdkvoice_voice_profile_domain" "this" {
  name        = var.name
  description = var.description
  region      = var.region

  server_side_encryption_configuration {
    kms_key_arn = var.server_side_encryption_configuration.kms_key_arn
  }

  tags = var.tags

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}