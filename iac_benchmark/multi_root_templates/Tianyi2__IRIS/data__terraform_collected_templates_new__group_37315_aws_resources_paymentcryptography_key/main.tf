resource "aws_paymentcryptography_key" "this" {
  exportable                = var.exportable
  enabled                   = var.enabled
  key_check_value_algorithm = var.key_check_value_algorithm
  tags                      = var.tags

  key_attributes {
    key_algorithm = var.key_attributes.key_algorithm
    key_class     = var.key_attributes.key_class
    key_usage     = var.key_attributes.key_usage

    key_modes_of_use {
      decrypt         = var.key_attributes.key_modes_of_use.decrypt
      derive_key      = var.key_attributes.key_modes_of_use.derive_key
      encrypt         = var.key_attributes.key_modes_of_use.encrypt
      generate        = var.key_attributes.key_modes_of_use.generate
      no_restrictions = var.key_attributes.key_modes_of_use.no_restrictions
      sign            = var.key_attributes.key_modes_of_use.sign
      unwrap          = var.key_attributes.key_modes_of_use.unwrap
      verify          = var.key_attributes.key_modes_of_use.verify
      wrap            = var.key_attributes.key_modes_of_use.wrap
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}