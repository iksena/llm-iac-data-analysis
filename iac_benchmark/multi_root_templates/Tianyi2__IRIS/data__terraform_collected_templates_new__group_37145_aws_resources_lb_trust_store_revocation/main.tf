resource "aws_lb_trust_store_revocation" "this" {
  region                        = var.region
  trust_store_arn               = var.trust_store_arn
  revocations_s3_bucket         = var.revocations_s3_bucket
  revocations_s3_key            = var.revocations_s3_key
  revocations_s3_object_version = var.revocations_s3_object_version
}