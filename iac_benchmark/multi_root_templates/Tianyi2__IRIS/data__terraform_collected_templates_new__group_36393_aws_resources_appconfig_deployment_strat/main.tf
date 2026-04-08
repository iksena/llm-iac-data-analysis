resource "aws_appconfig_deployment_strategy" "this" {
  region                         = var.region
  deployment_duration_in_minutes = var.deployment_duration_in_minutes
  growth_factor                  = var.growth_factor
  name                           = var.name
  replicate_to                   = var.replicate_to
  description                    = var.description
  final_bake_time_in_minutes     = var.final_bake_time_in_minutes
  growth_type                    = var.growth_type
  tags                           = var.tags
}