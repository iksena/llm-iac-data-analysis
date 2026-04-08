resource "aws_pinpointsmsvoicev2_phone_number" "this" {
  region                        = var.region
  deletion_protection_enabled   = var.deletion_protection_enabled
  iso_country_code              = var.iso_country_code
  message_type                  = var.message_type
  number_capabilities           = var.number_capabilities
  number_type                   = var.number_type
  opt_out_list_name             = var.opt_out_list_name
  registration_id               = var.registration_id
  self_managed_opt_outs_enabled = var.self_managed_opt_outs_enabled
  two_way_channel_arn           = var.two_way_channel_arn
  two_way_channel_enabled       = var.two_way_channel_enabled
  two_way_channel_role          = var.two_way_channel_role

  tags = var.tags
}