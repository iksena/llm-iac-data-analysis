data "aws_s3_objects" "this" {
  region        = var.region
  bucket        = var.bucket
  prefix        = var.prefix
  delimiter     = var.delimiter
  encoding_type = var.encoding_type
  max_keys      = var.max_keys
  start_after   = var.start_after
  fetch_owner   = var.fetch_owner
  request_payer = var.request_payer
}