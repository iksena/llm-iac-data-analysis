resource "aws_mq_configuration" "this" {
  data                    = var.data
  engine_type             = var.engine_type
  engine_version          = var.engine_version
  name                    = var.name
  authentication_strategy = var.authentication_strategy
  description             = var.description
  region                  = var.region
  tags                    = var.tags
}