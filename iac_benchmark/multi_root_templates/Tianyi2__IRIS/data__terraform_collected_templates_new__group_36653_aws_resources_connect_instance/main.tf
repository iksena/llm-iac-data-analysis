resource "aws_connect_instance" "this" {
  region                           = var.region
  auto_resolve_best_voices_enabled = var.auto_resolve_best_voices_enabled
  contact_flow_logs_enabled        = var.contact_flow_logs_enabled
  contact_lens_enabled             = var.contact_lens_enabled
  directory_id                     = var.directory_id
  early_media_enabled              = var.early_media_enabled
  identity_management_type         = var.identity_management_type
  inbound_calls_enabled            = var.inbound_calls_enabled
  instance_alias                   = var.instance_alias
  multi_party_conference_enabled   = var.multi_party_conference_enabled
  outbound_calls_enabled           = var.outbound_calls_enabled
  tags                             = var.tags
}