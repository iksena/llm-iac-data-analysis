resource "aws_networkmanager_core_network_policy_attachment" "this" {
  core_network_id = var.core_network_id
  policy_document = var.policy_document

  timeouts {
    update = var.timeouts_update
  }
}