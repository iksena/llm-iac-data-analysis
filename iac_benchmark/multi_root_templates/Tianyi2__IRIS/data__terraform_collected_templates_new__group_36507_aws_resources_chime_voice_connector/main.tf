resource "aws_chime_voice_connector" "this" {
  name               = var.name
  require_encryption = var.require_encryption
  region             = var.region
  aws_region         = var.aws_region
  tags               = var.tags
}