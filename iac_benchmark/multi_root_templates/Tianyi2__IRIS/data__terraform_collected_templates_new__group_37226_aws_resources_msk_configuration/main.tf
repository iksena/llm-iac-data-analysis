resource "aws_msk_configuration" "this" {
  name              = var.name
  description       = var.description
  kafka_versions    = var.kafka_versions
  server_properties = var.server_properties
}