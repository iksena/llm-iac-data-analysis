resource "aws_ecs_tag" "this" {
  region       = var.region
  resource_arn = var.resource_arn
  key          = var.key
  value        = var.value
}