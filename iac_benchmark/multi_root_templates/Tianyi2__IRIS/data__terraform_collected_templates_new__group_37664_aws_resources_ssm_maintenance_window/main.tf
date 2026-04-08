resource "aws_ssm_maintenance_window" "this" {
  name                       = var.name
  schedule                   = var.schedule
  cutoff                     = var.cutoff
  duration                   = var.duration
  description                = var.description
  allow_unassociated_targets = var.allow_unassociated_targets
  enabled                    = var.enabled
  end_date                   = var.end_date
  schedule_timezone          = var.schedule_timezone
  schedule_offset            = var.schedule_offset
  start_date                 = var.start_date
  tags                       = var.tags
}