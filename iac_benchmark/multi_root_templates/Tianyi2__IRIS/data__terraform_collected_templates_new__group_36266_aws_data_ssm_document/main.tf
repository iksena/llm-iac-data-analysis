data "aws_ssm_document" "this" {
  name             = var.name
  document_format  = var.document_format
  document_version = var.document_version

  provider = aws.region
}