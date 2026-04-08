resource "aws_codeconnections_connection" "this" {
  name          = var.name
  provider_type = var.provider_type
  host_arn      = var.host_arn
  tags          = var.tags

  # Lifecycle rule to prevent destruction when changing name or provider_type
  lifecycle {
    create_before_destroy = true
  }
}