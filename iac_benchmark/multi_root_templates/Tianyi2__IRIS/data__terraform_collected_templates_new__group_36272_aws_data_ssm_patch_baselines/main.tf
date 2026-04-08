data "aws_ssm_patch_baselines" "this" {
  region            = var.region
  default_baselines = var.default_baselines

  dynamic "filter" {
    for_each = var.filter
    content {
      key    = filter.value.key
      values = filter.value.values
    }
  }
}