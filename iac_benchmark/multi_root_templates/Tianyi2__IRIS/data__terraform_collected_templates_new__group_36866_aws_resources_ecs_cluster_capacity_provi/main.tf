resource "aws_ecs_cluster_capacity_providers" "this" {
  region             = var.region
  capacity_providers = var.capacity_providers
  cluster_name       = var.cluster_name

  dynamic "default_capacity_provider_strategy" {
    for_each = var.default_capacity_provider_strategy
    content {
      capacity_provider = default_capacity_provider_strategy.value.capacity_provider
      weight            = default_capacity_provider_strategy.value.weight
      base              = default_capacity_provider_strategy.value.base
    }
  }
}