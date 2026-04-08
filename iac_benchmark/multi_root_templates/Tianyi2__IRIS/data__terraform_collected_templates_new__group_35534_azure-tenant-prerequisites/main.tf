locals {
  pre_name       = "Cosmo Tech "
  post_name      = " ${var.cluster_name} For ${var.kubernetes_tenant_namespace}"
  subnet_name    = var.subnet_name
  identifier_uri = "https://${var.dns_record}.${var.dns_zone_name}/${var.kubernetes_tenant_namespace}"
  platform_url   = var.platform_url != "" ? var.platform_url : "https://${var.dns_record}.${var.dns_zone_name}${var.servlet_context_path}"
  vnet_iprange   = var.virtual_network_address_prefix
  tags           = var.tags

  app_tags = [
    "cosmotech",
    var.project_stage,
    var.customer_name,
    var.project_name,
    "HideApp",
    "WindowsAzureActiveDirectoryIntegratedApp",
    "terraformed"
  ]
  # Azure IDs
  microsoft_graph_resource_access_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph
  user_read_resource_access_id       = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
  platform_resource_access_id        = "6332363e-bcba-4c4a-a605-c25f23117400" # platform
  application_access_role_id         = "bb49d61f-8b6a-4a19-b5bd-06a29d6b8e60" # role
  # URIs
  public_client_redirect_uri = "http://localhost:8484/"
  webapp_spa_redirect_uri    = "http://localhost:3000/scenario"
}

data "azuread_users" "owners" {
  user_principal_names = var.owner_list
}

# Application Platform
resource "azuread_application" "platform" {
  display_name     = "${local.pre_name}Platform${local.post_name}"
  identifier_uris  = var.identifier_uri != "" ? [var.identifier_uri] : [local.identifier_uri]
  logo_image       = filebase64(var.image_path)
  owners           = data.azuread_users.owners.object_ids
  sign_in_audience = var.audience

  tags = local.app_tags

  required_resource_access {
    resource_app_id = local.microsoft_graph_resource_access_id

    resource_access {
      id   = local.user_read_resource_access_id
      type = "Scope"
    }
  }

  single_page_application {
    redirect_uris = ["${local.platform_url}/v3/swagger-ui/oauth2-redirect.html"]
  }

  web {
    implicit_grant {
      access_token_issuance_enabled = true
    }
  }

  api {
    requested_access_token_version = 2
    oauth2_permission_scope {
      admin_consent_description  = "Allow the application to use the Cosmo Tech Platform with user account"
      admin_consent_display_name = "Cosmo Tech Platform Impersonate"
      enabled                    = true
      id                         = local.platform_resource_access_id
      type                       = "User"
      user_consent_description   = "Allow the application to use the Cosmo Tech Platform with your account"
      user_consent_display_name  = "Cosmo Tech Platform Usage"
      value                      = "platform"
    }
  }

  dynamic "app_role" {
    for_each = toset(var.user_app_role)
    iterator = app_role

    content {
      allowed_member_types = [
        "User",
        "Application"
      ]
      description  = app_role.value.description
      display_name = app_role.value.display_name
      id           = app_role.value.id
      enabled      = true
      value        = app_role.value.role_value
    }
  }

  lifecycle {
    ignore_changes = [
      owners,
    ]
  }
}

resource "azuread_service_principal" "platform" {
  client_id                    = azuread_application.platform.client_id
  app_role_assignment_required = true
  owners                       = data.azuread_users.owners.object_ids
  tags                         = local.app_tags
}

resource "azuread_application_api_access" "add_role_api" {
  application_id = "/applications/${azuread_application.platform.object_id}"
  api_client_id  = azuread_application.platform.client_id
  role_ids       = [local.application_access_role_id]
  depends_on     = [azuread_service_principal.platform]
}

resource "azuread_app_role_assignment" "add_user_admin_platform" {
  app_role_id         = azuread_service_principal.platform.app_role_ids["Platform.Admin"]
  for_each            = toset(data.azuread_users.owners.object_ids)
  principal_object_id = each.key
  resource_object_id  = azuread_service_principal.platform.object_id
  depends_on          = [azuread_application_api_access.add_role_api]
}

resource "azuread_application_password" "platform_password" {
  display_name   = "platform_secret"
  application_id = azuread_application.platform.id
}

# Application swagger
resource "azuread_application" "swagger" {
  display_name     = "${local.pre_name}Swagger${local.post_name}"
  logo_image       = filebase64(var.image_path)
  owners           = data.azuread_users.owners.object_ids
  sign_in_audience = var.audience
  tags             = local.app_tags

  required_resource_access {
    resource_app_id = local.microsoft_graph_resource_access_id

    resource_access {
      id   = local.user_read_resource_access_id
      type = "Scope"
    }
  }

  required_resource_access {
    resource_app_id = azuread_application.platform.client_id

    resource_access {
      id   = local.platform_resource_access_id
      type = "Scope"
    }
  }

  single_page_application {
    redirect_uris = [
      "${local.platform_url}/${var.kubernetes_tenant_namespace}/v3/swagger-ui/oauth2-redirect.html"
    ]
  }

  web {
    implicit_grant {
      access_token_issuance_enabled = true
    }
  }
}

resource "azuread_service_principal" "swagger" {
  client_id                    = azuread_application.swagger.client_id
  app_role_assignment_required = false
  owners                       = data.azuread_users.owners.object_ids
  tags                         = local.app_tags
}

# Application restish
resource "azuread_application" "restish" {
  count            = var.create_restish ? 1 : 0
  display_name     = "${local.pre_name}Restish${local.post_name}"
  logo_image       = filebase64(var.image_path)
  owners           = data.azuread_users.owners.object_ids
  sign_in_audience = var.audience
  tags             = local.app_tags

  required_resource_access {
    resource_app_id = local.microsoft_graph_resource_access_id

    resource_access {
      id   = local.user_read_resource_access_id
      type = "Scope"
    }
  }

  required_resource_access {
    resource_app_id = azuread_application.platform.client_id

    resource_access {
      id   = local.application_access_role_id
      type = "Role"
    }
  }

  public_client {
    redirect_uris = [local.public_client_redirect_uri]
  }
}

resource "azuread_service_principal" "restish" {
  client_id                    = azuread_application.restish[0].client_id
  depends_on                   = [azuread_service_principal.swagger]
  count                        = var.create_restish ? 1 : 0
  app_role_assignment_required = false
  owners                       = data.azuread_users.owners.object_ids
  tags                         = local.app_tags
}

resource "azuread_application_password" "restish_password" {
  display_name   = "restish_secret"
  count          = var.create_restish ? 1 : 0
  application_id = azuread_application.restish[0].id
}

# Application powerbi
resource "azuread_application" "powerbi" {
  count            = var.create_powerbi ? 1 : 0
  display_name     = "${local.pre_name}PowerBI${local.post_name}"
  logo_image       = filebase64(var.image_path)
  owners           = data.azuread_users.owners.object_ids
  sign_in_audience = "AzureADMyOrg"
  tags             = local.app_tags
}

resource "azuread_service_principal" "powerbi" {
  client_id                    = azuread_application.powerbi[0].client_id
  depends_on                   = [azuread_service_principal.restish]
  count                        = var.create_powerbi ? 1 : 0
  app_role_assignment_required = false
  tags                         = local.app_tags
  owners                       = data.azuread_users.owners.object_ids
}

resource "azuread_application_password" "powerbi_password" {
  display_name   = "powerbi_secret"
  count          = var.create_powerbi ? 1 : 0
  application_id = azuread_application.powerbi[0].id
}

# Application babylon
resource "azuread_application" "babylon" {
  count            = var.create_babylon ? 1 : 0
  display_name     = "${local.pre_name}Babylon${local.post_name}"
  logo_image       = filebase64("cosmotech.png")
  owners           = data.azuread_users.owners.object_ids
  sign_in_audience = var.audience
  tags             = local.app_tags

  required_resource_access {
    resource_app_id = local.microsoft_graph_resource_access_id

    resource_access {
      id   = local.user_read_resource_access_id
      type = "Scope"
    }
  }

  required_resource_access {
    resource_app_id = azuread_application.platform.client_id

    resource_access {
      id   = local.application_access_role_id
      type = "Role"
    }
  }

  public_client {
    redirect_uris = [local.public_client_redirect_uri]
  }

  lifecycle {
    ignore_changes = [
      owners, required_resource_access,
    ]
  }
}

resource "azuread_service_principal" "babylon" {
  client_id                    = azuread_application.babylon[0].client_id
  count                        = var.create_babylon ? 1 : 0
  depends_on                   = [azuread_service_principal.swagger]
  app_role_assignment_required = false
  owners                       = data.azuread_users.owners.object_ids
  tags                         = local.app_tags
}

resource "azuread_application_password" "babylon_password" {
  display_name   = "babylon_secret"
  count          = var.create_babylon ? 1 : 0
  application_id = azuread_application.babylon[0].id
}
