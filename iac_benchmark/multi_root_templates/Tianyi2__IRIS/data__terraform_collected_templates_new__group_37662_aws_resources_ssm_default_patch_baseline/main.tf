resource "aws_ssm_default_patch_baseline" "this" {
  region           = var.region
  baseline_id      = var.baseline_id
  operating_system = var.operating_system
}