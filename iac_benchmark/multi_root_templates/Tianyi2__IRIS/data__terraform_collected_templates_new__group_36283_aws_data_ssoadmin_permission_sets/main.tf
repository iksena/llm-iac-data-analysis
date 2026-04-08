data "aws_ssoadmin_permission_sets" "this" {
  instance_arn = var.instance_arn
  region       = var.region
}