resource "aws_iot_provisioning_template" "this" {
  name                  = var.name
  description           = var.description
  enabled               = var.enabled
  provisioning_role_arn = var.provisioning_role_arn
  tags                  = var.tags
  template_body         = var.template_body
  type                  = var.type

  dynamic "pre_provisioning_hook" {
    for_each = var.pre_provisioning_hook != null ? [var.pre_provisioning_hook] : []
    content {
      payload_version = pre_provisioning_hook.value.payload_version
      target_arn      = pre_provisioning_hook.value.target_arn
    }
  }
}