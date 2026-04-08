data "aws_msk_kafka_version" "this" {
  region             = var.region
  preferred_versions = var.preferred_versions
  version            = var.kafka_version
}