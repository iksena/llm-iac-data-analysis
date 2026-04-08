resource "aws_directory_service_log_subscription" "this" {
  region         = var.region
  directory_id   = var.directory_id
  log_group_name = var.log_group_name
}