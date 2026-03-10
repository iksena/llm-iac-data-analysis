# ── variables.tf ────────────────────────────────────
variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where resources are to be deployed"
}

variable "alert_email_address" {
  type        = string
  description = "Email address where alert emails are sent"
}

variable "name_prefix" {
  type        = string
  description = "Name prefix to use for resources that need to be created (only lowercase characters and hyphens allowed)"
  default     = "azure-app-example--"
}

variable "app_service_name" {
  type        = string
  description = "Name for the app service"
  default     = "appservice"
}

# https://www.terraform.io/docs/providers/azurerm/r/application_insights.html#application_type
variable "app_insights_app_type" {
  type        = string
  description = "The type of Application Insights to create."
  default     = "other"
}

# https://azure.microsoft.com/en-gb/pricing/details/app-service/linux/
variable "app_service_plan_tier" {
  type        = string
  description = "App service plan's tier"
  default     = "PremiumV2"
}

variable "app_service_plan_size" {
  type        = string
  description = "App service plan's size"
  default     = "P1v2"
}

locals {
  cleansed_prefix = replace(var.name_prefix, "/[^a-zA-Z0-9]+/", "")
}


# ── outputs.tf ────────────────────────────────────
output "app_service_name" {
  description = "This is the unique name of the App Service that was created"
  value       = azurerm_app_service.current.name
}

output "app_service_url" {
  description = "This is the URL of the App Service that was created"
  value       = azurerm_app_service.current.default_site_hostname
}

output "container_registry" {
  value = azurerm_container_registry.current.login_server
}


# ── access_policies.tf ────────────────────────────────────
# Key vault access for the current client principal
resource "azurerm_key_vault_access_policy" "principal" {
  key_vault_id = azurerm_key_vault.current.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "get",
    "set",
    "delete"
  ]
}

# Key vault access for the App Service
resource "azurerm_key_vault_access_policy" "app_service" {
  key_vault_id = azurerm_key_vault.current.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_app_service.current.identity.0.principal_id

  secret_permissions = [
    "get",
  ]
}

# Key vault access for the App Service's next slot
resource "azurerm_key_vault_access_policy" "app_service_next_slot" {
  key_vault_id = azurerm_key_vault.current.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_app_service_slot.next.identity.0.principal_id

  secret_permissions = [
    "get",
  ]
}

# Pull access for the app service
resource "azurerm_role_assignment" "app_service_acr_pull" {
  scope                = azurerm_container_registry.current.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_app_service.current.identity.0.principal_id
}

# Pull access for the app service's next slot
resource "azurerm_role_assignment" "app_service_next_slot_acr_pull" {
  scope                = azurerm_container_registry.current.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_app_service_slot.next.identity.0.principal_id
}


# ── app_service.tf ────────────────────────────────────

locals {
  # Service plan needs to be unique only within the resource group
  app_service_plan_name = "${var.name_prefix}app-service-plan"
  # Needs to be globally unique
  app_service_name = "${var.name_prefix}${var.app_service_name}"

  # https://github.com/projectkudu/kudu/wiki/Configurable-settings
  app_service_settings = {
    # Enable if you need a persistant file storage (/home/ directory)
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false

    # Prevent recycling of the app when storage infra changes
    # https://github.com/projectkudu/kudu/wiki/Configurable-settings#disable-the-generation-of-bindings-in-applicationhostconfig
    WEBSITE_ADD_SITENAME_BINDINGS_IN_APPHOST_CONFIG = 1

    APPINSIGHTS_INSTRUMENTATIONKEY = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.current.vault_uri}secrets/app-insights-key)"
  }

  app_service_site_config = {
    always_on                 = true
    min_tls_version           = "1.2"
    health_check_path         = "/api/healthcheck"
    use_32_bit_worker_process = false
  }
}

resource "azurerm_app_service_plan" "current" {
  name                = local.app_service_plan_name
  location            = data.azurerm_resource_group.current.location
  resource_group_name = data.azurerm_resource_group.current.name
  kind                = "linux"
  reserved            = true

  sku {
    tier = var.app_service_plan_tier
    size = var.app_service_plan_size
  }
}

# App service
resource "azurerm_app_service" "current" {
  name                = local.app_service_name
  location            = data.azurerm_resource_group.current.location
  resource_group_name = data.azurerm_resource_group.current.name
  app_service_plan_id = azurerm_app_service_plan.current.id

  https_only = true

  site_config {
    always_on                 = local.app_service_site_config.always_on
    min_tls_version           = local.app_service_site_config.min_tls_version
    health_check_path         = local.app_service_site_config.health_check_path
    use_32_bit_worker_process = local.app_service_site_config.use_32_bit_worker_process
  }

  app_settings = local.app_service_settings

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      app_settings["DOCKER_CUSTOM_IMAGE_NAME"],
      site_config.0.scm_type,
    ]
  }

  logs {
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 100
      }
    }
  }

  # Use managed identity to login to ACR
  # https://github.com/Azure/app-service-linux-docs/blob/master/HowTo/use_system-assigned_managed_identities.md
  provisioner "local-exec" {
    command = "az resource update --ids ${azurerm_app_service.current.id} --set properties.acrUseManagedIdentityCreds=True -o none"
  }

  # Configure if you need EasyAuth
  # auth_settings {
  # }
}

# Deployment slot for better availability during deployments
resource "azurerm_app_service_slot" "next" {
  name                = "${local.app_service_name}-next"
  resource_group_name = data.azurerm_resource_group.current.name
  location            = data.azurerm_resource_group.current.location
  app_service_name    = azurerm_app_service.current.name
  app_service_plan_id = azurerm_app_service_plan.current.id

  site_config {
    always_on                 = local.app_service_site_config.always_on
    min_tls_version           = local.app_service_site_config.min_tls_version
    health_check_path         = local.app_service_site_config.health_check_path
    use_32_bit_worker_process = local.app_service_site_config.use_32_bit_worker_process
  }

  app_settings = local.app_service_settings

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      app_settings["DOCKER_CUSTOM_IMAGE_NAME"],
      site_config.0.scm_type,
    ]
  }
}


# ── data.tf ────────────────────────────────────
data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "current" {
  name = var.resource_group_name
}


# ── monitoring.tf ────────────────────────────────────
locals {
  healthcheck_endpoint = "https://${azurerm_app_service.current.default_site_hostname}/api/healthcheck"
}

# Action group to send an email for alerts
resource "azurerm_monitor_action_group" "current" {
  name                = "SendAlertEmail"
  resource_group_name = data.azurerm_resource_group.current.name
  short_name          = "Alert"

  email_receiver {
    name          = "sendtoemail"
    email_address = var.alert_email_address
  }
}

# Availability ping
resource "azurerm_application_insights_web_test" "app_availability" {
  name                    = "availability-${azurerm_app_service.current.name}"
  resource_group_name     = data.azurerm_resource_group.current.name
  location                = data.azurerm_resource_group.current.location
  application_insights_id = azurerm_application_insights.current.id
  kind                    = "ping"
  frequency               = 300
  timeout                 = 60
  enabled                 = true
  geo_locations           = ["emea-nl-ams-azr", "emea-ru-msa-edge", "emea-gb-db3-azr", "emea-fr-pra-edge", "us-va-ash-azr"]

  configuration = <<XML
<WebTest Name="Availability" Id="9a572603-75a7-4754-8f17-74d3a428d7fa" Enabled="True" CssProjectStructure="" CssIteration="" Timeout="120" WorkItemIds="" xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010" Description="" CredentialUserName="" CredentialPassword="" PreAuthenticate="True" Proxy="default" StopOnError="False" RecordedResultFile="" ResultsLocale="">
  <Items>
    <Request Method="GET" Guid="a3e2335b-cee0-ecd3-c892-ca25c94275b4" Version="1.1" Url="${local.healthcheck_endpoint}" ThinkTime="0" Timeout="120" ParseDependentRequests="False" FollowRedirects="True" RecordResult="True" Cache="False" ResponseTimeGoal="0" Encoding="utf-8" ExpectedHttpStatusCode="200" ExpectedResponseUrl="" ReportingName="" IgnoreHttpStatusCode="False" />
  </Items>
</WebTest>
XML

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# Availability ping failed alert
resource "azurerm_monitor_metric_alert" "app_availability" {
  name                = "${azurerm_app_service.current.name} server availability"
  resource_group_name = data.azurerm_resource_group.current.name
  # Both the availability web test AND the application insights need to be in the scope
  # https://github.com/terraform-providers/terraform-provider-azurerm/issues/8551
  scopes = [
    azurerm_application_insights_web_test.app_availability.id,
    azurerm_application_insights.current.id
  ]

  # Every 1 mins in 5 min window
  frequency   = "PT1M"
  window_size = "PT5M"
  # Critical
  severity = 0

  application_insights_web_test_location_availability_criteria {
    web_test_id           = azurerm_application_insights_web_test.app_availability.id
    component_id          = azurerm_application_insights.current.id
    failed_location_count = 3
  }

  action {
    action_group_id = azurerm_monitor_action_group.current.id
  }
}


# HTTP 5xx errors
resource "azurerm_monitor_metric_alert" "ms_5xx_errors" {
  name                = "${azurerm_app_service.current.name} server had HTTP 5xx errors"
  resource_group_name = data.azurerm_resource_group.current.name
  scopes = [
    azurerm_app_service.current.id
  ]

  # Every 15 mins in 15 min window
  frequency   = "PT15M"
  window_size = "PT15M"
  # Error
  severity = 1

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "Http5xx"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 0
  }

  action {
    action_group_id = azurerm_monitor_action_group.current.id
  }
}

# Dependency failures (e.g. HTTP request to another service or database query failed)
resource "azurerm_monitor_scheduled_query_rules_alert" "dependency_failures_in_app_service" {
  name                = "${azurerm_app_service.current.name} had dependency failures"
  resource_group_name = data.azurerm_resource_group.current.name
  location            = data.azurerm_resource_group.current.location
  data_source_id      = azurerm_application_insights.current.id
  frequency           = 15
  time_window         = 15
  # Error
  severity = 1
  query    = <<-QUERY
  dependencies
  | where resultCode == "False"
QUERY

  trigger {
    operator  = "GreaterThan"
    threshold = 0
  }

  action {
    action_group = [
      azurerm_monitor_action_group.current.id
    ]
  }
}


# ── provider.tf ────────────────────────────────────
# Configure the Azure Provider
provider "azurerm" {
  version                    = "= 2.37.0"
  skip_provider_registration = true
  features {}
}

provider "random" {
  version = "~> 2.3"
}

provider "template" {
  version = "~> 2.1"
}


# ── secrets.tf ────────────────────────────────────
# Application insights instrumentation key
resource "azurerm_key_vault_secret" "app_insights_instrumentation_key" {
  key_vault_id = azurerm_key_vault.current.id
  name         = "app-insights-key"
  value        = azurerm_application_insights.current.instrumentation_key

  depends_on = [azurerm_key_vault_access_policy.principal]
}


# ── shared.tf ────────────────────────────────────
# Since many services require a globally unique name (such as keyvault),
# generate random suffix for the resources
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

locals {
  # Key vault and ACR required globally unique names. Only alphanumeric characters allowed
  key_vault_name = "${local.cleansed_prefix}${random_string.suffix.result}"
  acr_name       = "${local.cleansed_prefix}${random_string.suffix.result}"

  # App insights needs to be unique only within the resource group
  app_insights_name = "${var.name_prefix}app-insights"
}

resource "azurerm_key_vault" "current" {
  name                = local.key_vault_name
  location            = data.azurerm_resource_group.current.location
  resource_group_name = data.azurerm_resource_group.current.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  soft_delete_enabled        = true
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  sku_name = "standard"
}

resource "azurerm_container_registry" "current" {
  name                = local.acr_name
  resource_group_name = data.azurerm_resource_group.current.name
  location            = data.azurerm_resource_group.current.location
  sku                 = "Standard"

  # We'll be using AD login
  admin_enabled = false
}

resource "azurerm_application_insights" "current" {
  name                = local.app_insights_name
  resource_group_name = data.azurerm_resource_group.current.name
  location            = data.azurerm_resource_group.current.location
  application_type    = var.app_insights_app_type
}
