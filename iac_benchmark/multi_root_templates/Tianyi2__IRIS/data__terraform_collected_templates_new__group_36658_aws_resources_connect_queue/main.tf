resource "aws_connect_queue" "this" {
  region                = var.region
  description           = var.description
  hours_of_operation_id = var.hours_of_operation_id
  instance_id           = var.instance_id
  max_contacts          = var.max_contacts
  name                  = var.name
  quick_connect_ids     = var.quick_connect_ids
  status                = var.status
  tags                  = var.tags

  dynamic "outbound_caller_config" {
    for_each = var.outbound_caller_config != null ? [var.outbound_caller_config] : []
    content {
      outbound_caller_id_name      = outbound_caller_config.value.outbound_caller_id_name
      outbound_caller_id_number_id = outbound_caller_config.value.outbound_caller_id_number_id
      outbound_flow_id             = outbound_caller_config.value.outbound_flow_id
    }
  }
}