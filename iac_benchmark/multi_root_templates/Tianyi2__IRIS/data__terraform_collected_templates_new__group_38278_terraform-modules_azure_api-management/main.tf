######################################
#     Naming and tagging Config      #
######################################
module "tags" {
  source = "git@github.com:UKHSA-Internal/devops-terraform-modules.git//terraform-modules/helpers/tags?ref=TF/helpers/tags/vALPHA_0.0.6"

  project         = var.tags.project
  client          = var.tags.client
  owner           = var.tags.owner
  environment     = var.tags.environment
  additional_tags = var.tags.additional_tags != null ? var.tags.additional_tags : {}
}

module "resource_name_prefix" {
  source = "git@github.com:UKHSA-Internal/devops-terraform-modules.git//terraform-modules/helpers/resource-name-prefix?ref=TF/helpers/resource-name-prefix/vALPHA_0.0.2"

  name = module.tags.tags["Project"]
  tags = module.tags.tags
}

##########################
#     Resource Group     #
##########################
data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

############################
#  REST API Configuration  #
############################
resource "azurerm_api_management" "api_management" {
  name                          = "${module.resource_name_prefix.resource_name}-api-management"
  location                      = data.azurerm_resource_group.resource_group.location
  resource_group_name           = data.azurerm_resource_group.resource_group.name
  publisher_name                = var.publisher_name
  publisher_email               = var.publisher_email
  sku_name                      = var.sku_name
  public_network_access_enabled = var.public_network_access_enabled

  # TODO: Review the below optional parameters
  # client_certificate_enabled    = var.api_management_optional.client_certificate_enabled
  # gateway_disabled              = var.api_management_optional.gateway_disabled
  # min_api_version               = var.api_management_optional.min_api_version
  # zones                         = var.api_management_optional.zones
  # notification_sender_email     = var.api_management_optional.notification_sender_email
  # public_ip_address_id          = var.api_management_optional.public_ip_address_id
  # public_network_access_enabled = var.api_management_optional.public_network_access_enabled
  # virtual_network_type          = var.api_management_optional.virtual_network_type
  # tags                          = var.api_management_optional.tags

  virtual_network_configuration {
    subnet_id = var.subnet_id
  }
}

resource "azurerm_api_management_api" "api" {
  for_each = var.apis

  name                = "${module.resource_name_prefix.resource_name}-${each.value.api_name}"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  api_management_name = azurerm_api_management.api_management.name
  revision            = each.value.revision
  display_name        = each.value.display_name
  path                = each.value.path
  protocols           = each.value.protocols

  import {
    content_format = each.value.content_format
    content_value  = each.value.content_value
  }
}

resource "azurerm_api_management_logger" "logger" {
  name                = "${module.resource_name_prefix.resource_name}-api-management-logger"
  api_management_name = azurerm_api_management.api_management.name
  resource_group_name = data.azurerm_resource_group.resource_group.name

  application_insights {
    instrumentation_key = azurerm_application_insights.application_insights.instrumentation_key
  }

  depends_on = [
    azurerm_api_management.api_management
  ]
}

resource "azurerm_api_management_api_diagnostic" "api_diagnostic" {
  for_each = var.apis

  identifier               = each.value.identifier
  resource_group_name      = data.azurerm_resource_group.resource_group.name
  api_management_name      = azurerm_api_management.api_management.name
  api_name                 = azurerm_api_management_api.api[each.key].name
  api_management_logger_id = azurerm_api_management_logger.logger.id

  sampling_percentage       = each.value.sampling_percentage
  always_log_errors         = each.value.always_log_errors
  log_client_ip             = each.value.log_client_ip
  verbosity                 = each.value.verbosity
  http_correlation_protocol = each.value.http_correlation_protocol

  frontend_request {
    body_bytes     = each.value.frontend_request.body_bytes
    headers_to_log = each.value.frontend_request.headers_to_log
  }

  frontend_response {
    body_bytes     = each.value.frontend_response.body_bytes
    headers_to_log = each.value.frontend_response.headers_to_log
  }

  backend_request {
    body_bytes     = each.value.backend_request.body_bytes
    headers_to_log = each.value.backend_request.headers_to_log
  }

  backend_response {
    body_bytes     = each.value.backend_response.body_bytes
    headers_to_log = each.value.backend_response.headers_to_log
  }

  depends_on = [
    azurerm_api_management.api_management,
    azurerm_api_management_api.api,
    azurerm_api_management_logger.logger
  ]
}

######################################
#  Azure App Insights Configuration  #
######################################
resource "azurerm_application_insights" "application_insights" {
  name                = "${module.resource_name_prefix.resource_name}-application-insights"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  application_type    = var.application_insights_type

  depends_on = [
    azurerm_api_management.api_management
  ]
}

# TODO: Review the below optional parameters
# resource "azurerm_private_endpoint" "api_management_endpoint" {
#   name                = "${var.api_management_name}-endpoint"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   subnet_id           = var.subnet_id
# yes
#   private_service_connection {
#     name                           = "${var.api_management_name}-connection"
#     private_connection_resource_id = azurerm_api_management.api_management.id
#     is_manual_connection           = var.api_endpoint_manual_connection
#     subresource_names              = ["Gateway"]
#   }
# }
