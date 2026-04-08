resource "aws_ssm_activation" "this" {
  region             = var.region
  name               = var.name
  description        = var.description
  expiration_date    = var.expiration_date
  iam_role           = var.iam_role
  registration_limit = var.registration_limit
  tags               = var.tags
}