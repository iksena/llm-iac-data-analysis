##########################
#     Naming Config      #
##########################
module "resource_name_prefix" {
  source = "git@github.com:UKHSA-Internal/devops-terraform-modules.git//terraform-modules/helpers/resource-name-prefix?ref=TF/helpers/resource-name-prefix/vALPHA_0.0.2"

  name = var.name
  tags = var.tags
}

##########################
#     Resource Group     #
##########################
data "azurerm_resource_group" "rg" {
  name = var.resource_group
}

############################
#  REST API Configuration  #
############################
resource "azurerm_application_gateway" "app_gw" {
  name                = "${module.resource_name_prefix.resource_name}-api-mgmt"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.sku_capacity
  }

  gateway_ip_configuration {
    name      = "${module.resource_name_prefix.resource_name}-gw-ip-config"
    subnet_id = var.subnet_id
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configurations
    content {
      name                 = frontend_ip_configuration.value.name
      public_ip_address_id = lookup(frontend_ip_configuration.value, "public_ip_address_id", null)
      subnet_id            = lookup(frontend_ip_configuration.value, "subnet_id", null)
    }
  }

  dynamic "frontend_port" {
    for_each = var.frontend_ports
    content {
      name = frontend_port.value.name
      port = frontend_port.value.port
    }
  }

  dynamic "http_listener" {
    for_each = var.http_listeners
    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = http_listener.value.protocol
      ssl_certificate_name           = lookup(http_listener.value, "ssl_certificate_name", null)
    }
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pools
    content {
      name = backend_address_pool.value.name
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings
    content {
      name                  = backend_http_settings.value.name
      cookie_based_affinity = backend_http_settings.value.cookie_based_affinity
      port                  = backend_http_settings.value.port
      protocol              = backend_http_settings.value.protocol
      request_timeout       = backend_http_settings.value.request_timeout
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.request_routing_rules
    content {
      name                       = request_routing_rule.value.name
      rule_type                  = request_routing_rule.value.rule_type
      http_listener_name         = request_routing_rule.value.http_listener_name
      backend_address_pool_name  = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name = request_routing_rule.value.backend_http_settings_name
    }
  }

  # TODO: Update broken WAF configuration
  # waf_configuration {
  #   enabled          = var.waf_configuration["enabled"]
  #   firewall_mode    = var.waf_configuration["firewall_mode"]
  #   rule_set_type    = var.waf_configuration["rule_set_type"]
  #   rule_set_version = var.waf_configuration["rule_set_version"]

  #   dynamic "rule" {
  #     for_each = var.waf_configuration["rules"]
  #     content {
  #       name = rule.value.name
  #     }
  #   }
  # }

  tags = var.tags
}


