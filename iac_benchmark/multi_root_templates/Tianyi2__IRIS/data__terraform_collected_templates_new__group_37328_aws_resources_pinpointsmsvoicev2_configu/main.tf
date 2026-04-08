resource "aws_pinpointsmsvoicev2_configuration_set" "this" {
  name                 = var.name
  default_sender_id    = var.default_sender_id
  default_message_type = var.default_message_type
  tags                 = var.tags
}