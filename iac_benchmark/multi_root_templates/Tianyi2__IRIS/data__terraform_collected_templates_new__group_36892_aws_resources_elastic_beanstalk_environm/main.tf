resource "aws_elastic_beanstalk_environment" "this" {
  region                 = var.region
  name                   = var.name
  application            = var.application
  cname_prefix           = var.cname_prefix
  description            = var.description
  tier                   = var.tier
  solution_stack_name    = var.solution_stack_name
  template_name          = var.template_name
  platform_arn           = var.platform_arn
  wait_for_ready_timeout = var.wait_for_ready_timeout
  poll_interval          = var.poll_interval
  version_label          = var.version_label
  tags                   = var.tags

  dynamic "setting" {
    for_each = var.settings
    content {
      namespace = setting.value.namespace
      name      = setting.value.name
      value     = setting.value.value
      resource  = try(setting.value.resource, null)
    }
  }
}