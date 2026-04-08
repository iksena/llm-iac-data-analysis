resource "aws_datazone_asset_type" "this" {
  domain_identifier         = var.domain_identifier
  name                      = var.name
  owning_project_identifier = var.owning_project_identifier

  region      = var.region
  description = var.description
  dynamic "forms_input" {
    for_each = var.forms_input != null ? var.forms_input : {}
    content {
      map_block_key   = forms_input.key
      required        = forms_input.value.required
      type_identifier = forms_input.value.type_identifier
      type_revision   = forms_input.value.type_revision
    }
  }

  timeouts {
    create = var.create_timeout
  }
}