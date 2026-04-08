data "aws_signer_signing_profile" "this" {
  name   = var.name
  region = var.region
}