data "aws_ssoadmin_permission_set" "this" {
  region       = var.region
  arn          = var.arn
  instance_arn = var.instance_arn
  name         = var.name
}