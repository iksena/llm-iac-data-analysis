data "aws_backup_selection" "this" {
  region       = var.region
  plan_id      = var.plan_id
  selection_id = var.selection_id
}