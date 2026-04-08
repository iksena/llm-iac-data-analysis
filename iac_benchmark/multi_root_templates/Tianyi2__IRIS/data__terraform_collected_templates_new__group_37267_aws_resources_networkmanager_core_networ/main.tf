resource "aws_networkmanager_core_network" "this" {
  global_network_id    = var.global_network_id
  base_policy_document = var.base_policy_document
  base_policy_regions  = var.base_policy_regions
  create_base_policy   = var.create_base_policy
  description          = var.description
  tags                 = var.tags

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }
}