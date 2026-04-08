resource "aws_elastic_beanstalk_configuration_template" "this" {
  name                = var.name
  application         = var.application
  description         = var.description
  environment_id      = var.environment_id
  solution_stack_name = var.solution_stack_name

  dynamic "setting" {
    for_each = var.setting
    content {
      namespace = setting.value.namespace
      name      = setting.value.name
      value     = setting.value.value
      resource  = setting.value.resource
    }
  }
}