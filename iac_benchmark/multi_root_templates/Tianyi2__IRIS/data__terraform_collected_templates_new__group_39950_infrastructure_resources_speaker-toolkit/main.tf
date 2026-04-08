data "azurerm_client_config" "current" {}

module "AzureResourceTypes" {
  source = "../../modules/azure-resource-types"
}

module "ResourceTags" {
  source = "../../modules/resource-tags"
}

# Resource Group (e.g. rg-SpeakerToolkit-dev-eus2)
resource "azurerm_resource_group" "rgSpeakerToolkit" {
  name     = "${module.AzureResourceTypes.resource_type_resource_group}-SpeakerToolkit-${var.resource_name_environment}-${var.resource_name_location}"
  location = var.azure_region
  tags = {
    Product     = module.ResourceTags.resource_tag_product_name
    Criticality = module.ResourceTags.resource_tag_criticality
    CostCenter  = "${module.ResourceTags.resource_tag_cost_center}-${var.resource_name_environment}"
    DR          = module.ResourceTags.resource_tag_dr
    Env         = var.resource_name_environment
  }
}

# Azure App Configuration (e.g. appcs-SpeakerToolkit-dev-eus2)
resource "azurerm_app_configuration" "appcsSpeakerToolkit" {
  name                = "${module.AzureResourceTypes.resource_type_app_configuration}-SpeakerToolkit-${var.resource_name_environment}-${var.resource_name_location}"
  resource_group_name = azurerm_resource_group.rgSpeakerToolkit.name
  location            = azurerm_resource_group.rgSpeakerToolkit.location
  sku                 = "standard"
  tags = {
    Product     = module.ResourceTags.resource_tag_product_name
    Criticality = module.ResourceTags.resource_tag_criticality
    CostCenter  = "${module.ResourceTags.resource_tag_cost_center}-${var.resource_name_environment}"
    DR          = module.ResourceTags.resource_tag_dr
    Env         = var.resource_name_environment
  }
}

## Azure Key Vault (e.g. kvSpeakerToolkitDevEUS2)
resource "azurerm_key_vault" "kvSpeakerToolkit" {
  name                = "${module.AzureResourceTypes.resource_type_key_vault}SpeakerToolkit${var.resource_name_environment}-${var.resource_name_location}"
  location            = azurerm_resource_group.rgSpeakerToolkit.location
  resource_group_name = azurerm_resource_group.rgSpeakerToolkit.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    key_permissions = [
      "Get",
    ]
    secret_permissions = [
      "Get",
    ]
    storage_permissions = [
      "Get",
    ]
  }
  tags = {
    Product     = module.ResourceTags.resource_tag_product_name
    Criticality = module.ResourceTags.resource_tag_criticality
    CostCenter  = "${module.ResourceTags.resource_tag_cost_center}-${var.resource_name_environment}"
    DR          = module.ResourceTags.resource_tag_dr
    Env         = var.resource_name_environment
  }
}

## SQL Server (e.g. sql-speakertoolkit-dev-eus2)
resource "azurerm_mssql_server" "sqlSpeakerToolkit" {
  name                         = "${module.AzureResourceTypes.resource_type_sql_server}-speakertoolkit-${var.resource_name_environment}-${var.resource_name_location}"
  resource_group_name          = azurerm_resource_group.rgSpeakerToolkit.name
  location                     = azurerm_resource_group.rgSpeakerToolkit.location
  version                      = "12.0"
  administrator_login          = "CloudSA"
  administrator_login_password = var.sql_admin_password
  tags = {
    Product     = module.ResourceTags.resource_tag_product_name
    Criticality = module.ResourceTags.resource_tag_criticality
    CostCenter  = "${module.ResourceTags.resource_tag_cost_center}-${var.resource_name_environment}"
    DR          = module.ResourceTags.resource_tag_dr
    Env         = var.resource_name_environment
  }
}

## SQL Database (e.g. sqldb-SpeakerToolkit-dev-eus2)
resource "azurerm_mssql_database" "sqldbSpeakerToolkit" {
  name      = "${module.AzureResourceTypes.resource_type_sql_datbase}-SpeakerToolkit-${var.resource_name_environment}-${var.resource_name_location}"
  server_id = azurerm_mssql_server.sqlSpeakerToolkit.id
}



# #############################################################################
#                               Azure Function
# #############################################################################

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "logSpeakerToolkit" {
  name                = "${module.AzureResourceTypes.resource_type_log_analytics_workspace}-SpeakerToolkit-${var.resource_name_environment}-${var.resource_name_location}"
  location            = azurerm_resource_group.rgSpeakerToolkit.location
  resource_group_name = azurerm_resource_group.rgSpeakerToolkit.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags = {
    Product     = module.ResourceTags.resource_tag_product_name
    Criticality = module.ResourceTags.resource_tag_criticality
    CostCenter  = "${module.ResourceTags.resource_tag_cost_center}-${var.resource_name_environment}"
    DR          = module.ResourceTags.resource_tag_dr
    Env         = var.resource_name_environment
  }
}

# Application Insights (e.g. ai-SpeakerToolkit-dev-eus2)
resource "azurerm_application_insights" "aiSpeakerToolkit" {
  name                = "${module.AzureResourceTypes.resource_type_application_insights}-SpeakerToolkit-${var.resource_name_environment}-${var.resource_name_location}"
  location            = azurerm_resource_group.rgSpeakerToolkit.location
  resource_group_name = azurerm_resource_group.rgSpeakerToolkit.name
  workspace_id        = azurerm_log_analytics_workspace.logSpeakerToolkit.id
  application_type    = "web"
  tags = {
    Product     = module.ResourceTags.resource_tag_product_name
    Criticality = module.ResourceTags.resource_tag_criticality
    CostCenter  = "${module.ResourceTags.resource_tag_cost_center}-${var.resource_name_environment}"
    DR          = module.ResourceTags.resource_tag_dr
    Env         = var.resource_name_environment
  }
}

# Storage Account (e.g. stspeakertoolkitdeveus2)
resource "azurerm_storage_account" "stSpeakerToolkit" {
  name                     = "${module.AzureResourceTypes.resource_type_storage_account}speakertoolkit${var.resource_name_environment}${var.resource_name_location}"
  resource_group_name      = azurerm_resource_group.rgSpeakerToolkit.name
  location                 = azurerm_resource_group.rgSpeakerToolkit.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# App Service Plan (e.g. asp-SpeakerToolkit-dev-eus2)
resource "azurerm_service_plan" "aspSpeakerToolkit" {
  name                = "${module.AzureResourceTypes.resource_type_app_service_plan}-SpeakerToolkit-${var.resource_name_environment}-${var.resource_name_location}"
  resource_group_name = azurerm_resource_group.rgSpeakerToolkit.name
  location            = azurerm_resource_group.rgSpeakerToolkit.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "funcSpeakerToolkit" {
  name                       = "${module.AzureResourceTypes.resource_type_function_app}-SpeakerToolkit-${var.resource_name_environment}-${var.resource_name_location}"
  resource_group_name        = azurerm_resource_group.rgSpeakerToolkit.name
  location                   = azurerm_resource_group.rgSpeakerToolkit.location
  service_plan_id            = azurerm_service_plan.aspSpeakerToolkit.id
  storage_account_name       = azurerm_storage_account.stSpeakerToolkit.name
  storage_account_access_key = azurerm_storage_account.stSpeakerToolkit.primary_access_key
  site_config {
    application_stack {
      dotnet_version              = "8.0"
      use_dotnet_isolated_runtime = "true"
    }
    application_insights_connection_string = "${azurerm_application_insights.aiSpeakerToolkit.connection_string}"
    application_insights_key               = "${azurerm_application_insights.aiSpeakerToolkit.instrumentation_key}"
  }
  app_settings = {
    SCM_DO_BUILD_DURING_DEPLOYMENT         = "0"
    WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED = "1"
  }
}

resource "azurerm_linux_function_app_slot" "funcSpeakerToolkitStaging" {
  name                 = "staging"
  function_app_id      = azurerm_linux_function_app.funcSpeakerToolkit.id
  storage_account_name = azurerm_storage_account.stSpeakerToolkit.name
  site_config {
    application_stack {
      dotnet_version              = "8.0"
      use_dotnet_isolated_runtime = "true"
    }
    application_insights_connection_string = "${azurerm_application_insights.aiSpeakerToolkit.connection_string}"
    application_insights_key               = "${azurerm_application_insights.aiSpeakerToolkit.instrumentation_key}"
  }
  app_settings = {
    SCM_DO_BUILD_DURING_DEPLOYMENT         = "0"
    WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED = "1"
  }
}






# API Management (e.g. apim-SiteSpeaker-dev-eus2)
resource "azurerm_api_management" "apimSpeakerToolkit" {
  name     = "${module.AzureResourceTypes.resource_type_api_management}-SpeakerToolkit-${var.resource_name_environment}-${var.resource_name_location}"
  location            = azurerm_resource_group.rgSpeakerToolkit.location
  resource_group_name = azurerm_resource_group.rgSpeakerToolkit.name
  publisher_name      = "Speaker Toolkit"
  publisher_email     = "chadgreen@chadgreen.com"
  sku_name = "Developer_1"
}