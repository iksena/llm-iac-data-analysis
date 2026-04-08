data "aws_ecs_service" "this" {
  region       = var.region
  service_name = var.service_name
  cluster_arn  = var.cluster_arn
}