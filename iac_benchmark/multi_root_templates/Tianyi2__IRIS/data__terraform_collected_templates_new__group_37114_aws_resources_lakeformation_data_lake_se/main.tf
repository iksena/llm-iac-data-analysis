resource "aws_lakeformation_data_lake_settings" "this" {
  region                                = var.region
  admins                                = var.admins
  allow_external_data_filtering         = var.allow_external_data_filtering
  allow_full_table_external_data_access = var.allow_full_table_external_data_access
  authorized_session_tag_value_list     = var.authorized_session_tag_value_list
  catalog_id                            = var.catalog_id
  external_data_filtering_allow_list    = var.external_data_filtering_allow_list
  parameters                            = var.parameters
  read_only_admins                      = var.read_only_admins
  trusted_resource_owners               = var.trusted_resource_owners

  dynamic "create_database_default_permissions" {
    for_each = var.create_database_default_permissions != null ? var.create_database_default_permissions : []
    content {
      permissions = create_database_default_permissions.value.permissions
      principal   = create_database_default_permissions.value.principal
    }
  }

  dynamic "create_table_default_permissions" {
    for_each = var.create_table_default_permissions != null ? var.create_table_default_permissions : []
    content {
      permissions = create_table_default_permissions.value.permissions
      principal   = create_table_default_permissions.value.principal
    }
  }
}