resource "aws_lb_trust_store" "this" {
  name                                     = var.name
  name_prefix                              = var.name_prefix
  ca_certificates_bundle_s3_bucket         = var.ca_certificates_bundle_s3_bucket
  ca_certificates_bundle_s3_key            = var.ca_certificates_bundle_s3_key
  ca_certificates_bundle_s3_object_version = var.ca_certificates_bundle_s3_object_version
  tags                                     = var.tags
}