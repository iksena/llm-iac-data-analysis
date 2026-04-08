resource "aws_backup_region_settings" "this" {
  region                              = var.region
  resource_type_opt_in_preference     = var.resource_type_opt_in_preference
  resource_type_management_preference = var.resource_type_management_preference
}