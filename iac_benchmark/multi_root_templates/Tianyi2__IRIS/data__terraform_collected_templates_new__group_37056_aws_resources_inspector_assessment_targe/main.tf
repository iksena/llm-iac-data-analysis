resource "aws_inspector_assessment_target" "this" {
  region             = var.region
  name               = var.name
  resource_group_arn = var.resource_group_arn
}