resource "aws_workspaces_directory" "this" {
  region                          = var.region
  directory_id                    = var.directory_id
  subnet_ids                      = var.subnet_ids
  ip_group_ids                    = var.ip_group_ids
  tags                            = var.tags
  workspace_type                  = var.workspace_type
  workspace_directory_name        = var.workspace_directory_name
  workspace_directory_description = var.workspace_directory_description
  user_identity_type              = var.user_identity_type

  dynamic "certificate_based_auth_properties" {
    for_each = var.certificate_based_auth_properties != null ? [var.certificate_based_auth_properties] : []
    content {
      certificate_authority_arn = certificate_based_auth_properties.value.certificate_authority_arn
      status                    = certificate_based_auth_properties.value.status
    }
  }

  dynamic "saml_properties" {
    for_each = var.saml_properties != null ? [var.saml_properties] : []
    content {
      relay_state_parameter_name = saml_properties.value.relay_state_parameter_name
      status                     = saml_properties.value.status
      user_access_url            = saml_properties.value.user_access_url
    }
  }

  dynamic "self_service_permissions" {
    for_each = var.self_service_permissions != null ? [var.self_service_permissions] : []
    content {
      change_compute_type  = self_service_permissions.value.change_compute_type
      increase_volume_size = self_service_permissions.value.increase_volume_size
      rebuild_workspace    = self_service_permissions.value.rebuild_workspace
      restart_workspace    = self_service_permissions.value.restart_workspace
      switch_running_mode  = self_service_permissions.value.switch_running_mode
    }
  }

  dynamic "workspace_access_properties" {
    for_each = var.workspace_access_properties != null ? [var.workspace_access_properties] : []
    content {
      device_type_android    = workspace_access_properties.value.device_type_android
      device_type_chromeos   = workspace_access_properties.value.device_type_chromeos
      device_type_ios        = workspace_access_properties.value.device_type_ios
      device_type_linux      = workspace_access_properties.value.device_type_linux
      device_type_osx        = workspace_access_properties.value.device_type_osx
      device_type_web        = workspace_access_properties.value.device_type_web
      device_type_windows    = workspace_access_properties.value.device_type_windows
      device_type_zeroclient = workspace_access_properties.value.device_type_zeroclient
    }
  }

  dynamic "workspace_creation_properties" {
    for_each = var.workspace_creation_properties != null ? [var.workspace_creation_properties] : []
    content {
      custom_security_group_id            = workspace_creation_properties.value.custom_security_group_id
      default_ou                          = workspace_creation_properties.value.default_ou
      enable_internet_access              = workspace_creation_properties.value.enable_internet_access
      enable_maintenance_mode             = workspace_creation_properties.value.enable_maintenance_mode
      user_enabled_as_local_administrator = workspace_creation_properties.value.user_enabled_as_local_administrator
    }
  }

  dynamic "active_directory_config" {
    for_each = var.active_directory_config != null ? [var.active_directory_config] : []
    content {
      domain_name                = active_directory_config.value.domain_name
      service_account_secret_arn = active_directory_config.value.service_account_secret_arn
    }
  }
}