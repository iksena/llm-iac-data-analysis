resource "aws_auditmanager_control" "this" {
  name                     = var.name
  region                   = var.region
  action_plan_instructions = var.action_plan_instructions
  action_plan_title        = var.action_plan_title
  description              = var.description
  tags                     = var.tags
  testing_information      = var.testing_information

  dynamic "control_mapping_sources" {
    for_each = var.control_mapping_sources
    content {
      source_name          = control_mapping_sources.value.source_name
      source_set_up_option = control_mapping_sources.value.source_set_up_option
      source_type          = control_mapping_sources.value.source_type
      source_description   = control_mapping_sources.value.source_description
      source_frequency     = control_mapping_sources.value.source_frequency
      troubleshooting_text = control_mapping_sources.value.troubleshooting_text

      dynamic "source_keyword" {
        for_each = control_mapping_sources.value.source_keyword != null ? [control_mapping_sources.value.source_keyword] : []
        content {
          keyword_input_type = source_keyword.value.keyword_input_type
          keyword_value      = source_keyword.value.keyword_value
        }
      }
    }
  }
}