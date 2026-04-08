resource "aws_config_organization_conformance_pack" "this" {
  region                 = var.region
  name                   = var.name
  delivery_s3_bucket     = var.delivery_s3_bucket
  delivery_s3_key_prefix = var.delivery_s3_key_prefix
  excluded_accounts      = var.excluded_accounts
  template_body          = var.template_body
  template_s3_uri        = var.template_s3_uri

  dynamic "input_parameter" {
    for_each = var.input_parameters
    content {
      parameter_name  = input_parameter.value.parameter_name
      parameter_value = input_parameter.value.parameter_value
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}