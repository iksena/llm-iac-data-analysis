resource "aws_cognito_user" "this" {
  user_pool_id             = var.user_pool_id
  username                 = var.username
  region                   = var.region
  attributes               = var.attributes
  client_metadata          = var.client_metadata
  desired_delivery_mediums = var.desired_delivery_mediums
  enabled                  = var.enabled
  force_alias_creation     = var.force_alias_creation
  message_action           = var.message_action
  password                 = var.password
  temporary_password       = var.temporary_password
  validation_data          = var.validation_data
}