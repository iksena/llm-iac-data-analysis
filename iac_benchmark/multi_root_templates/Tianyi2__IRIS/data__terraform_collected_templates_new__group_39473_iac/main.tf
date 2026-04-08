data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

data "azuread_group" "aad_admins" {
  display_name     = "Developers"
  security_enabled = true
}

data "azuread_service_principal" "msi" {
  object_id = azurerm_linux_web_app.api.identity.0.principal_id
}

locals {
  connection_string = "Server=tcp:sql-toggleon-${var.env}.database.windows.net,1433;Initial Catalog=sqldb-toggleon-${var.env};Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;Authentication=Active Directory Default;"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-toggleon-${var.env}-001"
  location = var.location

  tags = {
    environment = var.env
  }
}

resource "azurerm_log_analytics_workspace" "logs" {
  name                = "log-toggleon-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    environment = var.env
  }
}

resource "azurerm_application_insights" "ai" {
  name                = "ai-toggleon-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  workspace_id        = azurerm_log_analytics_workspace.logs.id
  application_type    = "web"

  tags = {
    environment = var.env
  }
}

resource "azurerm_servicebus_namespace" "sbns" {
  name                = "sbns-toggleon-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"

  tags = {
    environment = var.env
  }
}

resource "azurerm_servicebus_namespace_authorization_rule" "sb-auth-rule" {
  name         = "sbnsar-toggleon-${var.env}"
  namespace_id = azurerm_servicebus_namespace.sbns.id

  listen = true
  send   = true
  manage = false
}

resource "azurerm_servicebus_queue" "sbq" {
  for_each     = toset(var.servicebus_queues)
  name         = "sbq-${each.value}"
  namespace_id = azurerm_servicebus_namespace.sbns.id
}

resource "azurerm_servicebus_topic" "sbt-sbq" {
  for_each     = toset(var.servicebus_queues)
  name         = "sbt-${each.value}"
  namespace_id = azurerm_servicebus_namespace.sbns.id
}

resource "azurerm_servicebus_subscription" "sbq-sbts" {
  for_each           = toset(var.servicebus_queues)
  name               = azurerm_servicebus_queue.sbq[each.key].name
  topic_id           = azurerm_servicebus_topic.sbt-sbq[each.key].id
  max_delivery_count = 1
}

resource "azurerm_servicebus_topic" "sbt" {
  for_each     = toset(var.servicebus_topics)
  name         = "sbt-${each.value}"
  namespace_id = azurerm_servicebus_namespace.sbns.id
}

resource "azurerm_servicebus_subscription" "api-sbts" {
  for_each           = toset(var.api_servicebus_subscriptions)
  name               = azurerm_linux_web_app.api.name
  topic_id           = azurerm_servicebus_topic.sbt[each.key].id
  max_delivery_count = 1
}

resource "azurerm_servicebus_subscription" "func-sbts" {
  for_each           = toset(var.func_servicebus_subscriptions)
  name               = azurerm_linux_function_app.func.name
  topic_id           = azurerm_servicebus_topic.sbt[each.key].id
  max_delivery_count = 1
}

resource "random_password" "db-admin-password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_mssql_server" "sql" {
  name                          = "sql-toggleon-${var.env}"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = "dbadmin"
  administrator_login_password  = random_password.db-admin-password.result
  minimum_tls_version           = "1.2"
  public_network_access_enabled = true

  azuread_administrator {
    login_username = data.azuread_group.aad_admins.display_name
    object_id      = data.azuread_group.aad_admins.object_id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = var.env
  }
}

resource "azuread_directory_role" "ad-dr" {
  display_name = "Directory Readers"
}

resource "azuread_directory_role_assignment" "ad-dra" {
  role_id             = azuread_directory_role.ad-dr.id
  principal_object_id = azurerm_mssql_server.sql.identity.0.principal_id
}

resource "azurerm_mssql_firewall_rule" "sql-firewall-rule" {
  name             = "sfwr-toggleon-${var.env}"
  server_id        = azurerm_mssql_server.sql.id
  start_ip_address = var.ip_address
  end_ip_address   = var.ip_address
}

resource "azurerm_mssql_firewall_rule" "az-sql-firewall-rule" {
  name             = "AllowAllWindowsAzureIps"
  server_id        = azurerm_mssql_server.sql.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_database" "db" {
  name         = "sqldb-toggleon-${var.env}"
  server_id    = azurerm_mssql_server.sql.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  sku_name     = "Basic"

  tags = {
    environment = var.env
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-toggleon-${var.env}"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    environment = var.env
  }
}

resource "azurerm_subnet" "integration-subnet" {
  name                 = "snet-toggleon-${var.env}-001"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }

  lifecycle {
    ignore_changes = [
      delegation
    ]
  }
}

resource "azurerm_subnet" "endpoint-subnet" {
  name                 = "snet-toggleon-${var.env}-002"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_private_dns_zone" "dns" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_endpoint" "pep" {
  name                = "pep-toggleon-${var.env}-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.endpoint-subnet.id

  private_dns_zone_group {
    name                 = "dns-${azurerm_mssql_server.sql.name}"
    private_dns_zone_ids = [azurerm_private_dns_zone.dns.id]
  }

  private_service_connection {
    name                           = "link-${azurerm_mssql_server.sql.name}"
    private_connection_resource_id = azurerm_mssql_server.sql.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = "false"
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns-link" {
  name                  = "pl-toggleon-${var.env}-001"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_static_site" "admin" {
  name                = "stapp-toggleon-admin-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  tags = {
    environment = var.env
  }
}

resource "azurerm_service_plan" "asp-api" {
  name                = "asp-toggleon-api-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "S1"

  depends_on = [
    azurerm_service_plan.asp-func
  ]

  tags = {
    environment = var.env
  }
}

resource "azurerm_linux_web_app" "api" {
  name                      = "app-toggleon-api-${var.env}"
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  service_plan_id           = azurerm_service_plan.asp-api.id
  virtual_network_subnet_id = azurerm_subnet.integration-subnet.id

  site_config {
    application_stack {
      dotnet_version = "8.0"
    }
    cors {
      allowed_origins = ["https://${azurerm_static_site.admin.default_host_name}"]
    }
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "WEBSITE_WEBDEPLOY_USE_SCM"                     = false
    "APPINSIGHTS_INSTRUMENTATIONKEY"                = azurerm_application_insights.ai.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING"         = azurerm_application_insights.ai.connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION"    = "~3"
    "ServiceBusConnection__fullyQualifiedNamespace" = "sbns-toggleon-dev.servicebus.windows.net"
  }

  connection_string {
    name  = "ToggleOn"
    type  = "SQLServer"
    value = local.connection_string
  }

  tags = {
    environment = var.env
  }
}

resource "azurerm_storage_account" "sa" {
  name                     = "satoggleonfuncdev"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "asp-func" {
  name                = "asp-toggleon-func-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "func" {
  name                = "func-toggleon-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
  service_plan_id            = azurerm_service_plan.asp-func.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      dotnet_version              = "8.0"
      use_dotnet_isolated_runtime = true
    }

    application_insights_key               = azurerm_application_insights.ai.instrumentation_key
    application_insights_connection_string = azurerm_application_insights.ai.connection_string
  }

  app_settings = {
    "AzureSignalRConnectionString"                  = "Endpoint=https://sigr-toggleon-${var.env}.service.signalr.net;AuthType=azure.msi;Version=1.0;"
    "ServiceBusConnection__fullyQualifiedNamespace" = "sbns-toggleon-dev.servicebus.windows.net"
    "ApiBaseAddress"                                = "https://app-toggleon-api-${var.env}.azurewebsites.net"
  }

  tags = {
    environment = var.env
  }
}

resource "azurerm_signalr_service" "sigr" {
  name                = "sigr-toggleon-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_mode        = "Serverless"

  sku {
    name     = "Free_F1"
    capacity = 1
  }

  cors {
    allowed_origins = ["https://func-toggleon-${var.env}.azurewebsites.net"]
  }

  identity {
    type = "SystemAssigned"
  }

  upstream_endpoint {
    hub_pattern      = ["feature"]
    category_pattern = ["connections", "messages"]
    event_pattern    = ["*"]
    url_template     = "https://func-toggleon-${var.env}.azurewebsites.net/runtime/webhooks/signalr?code="
  }

  tags = {
    environment = var.env
  }
}

resource "azurerm_role_assignment" "ra-sb-group" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Azure Service Bus Data Owner"
  principal_id         = data.azuread_group.aad_admins.object_id
}

resource "azurerm_role_assignment" "ra-sigr-group" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "SignalR Service Owner"
  principal_id         = data.azuread_group.aad_admins.object_id
}

resource "azurerm_role_assignment" "ra-sb-api" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Azure Service Bus Data Owner"
  principal_id         = azurerm_linux_web_app.api.identity.0.principal_id
}

resource "azurerm_role_assignment" "ra-sb-func" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Azure Service Bus Data Owner"
  principal_id         = azurerm_linux_function_app.func.identity.0.principal_id
}

resource "azurerm_role_assignment" "ra-sigr-func" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "SignalR Service Owner"
  principal_id         = azurerm_linux_function_app.func.identity.0.principal_id
}

output "ai-connection-string" {
  value     = azurerm_application_insights.ai.connection_string
  sensitive = true
}

output "ai-instrumentation_key" {
  value     = azurerm_application_insights.ai.instrumentation_key
  sensitive = true
}

output "db-admin-password" {
  value     = random_password.db-admin-password.result
  sensitive = true
}

output "swa-deployment-token" {
  value     = azurerm_static_site.admin.api_key
  sensitive = true
}
