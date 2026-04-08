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
# Web Application Firewall #
############################
locals {
  predefined_managed_rules = [
    {
      type    = "OWASP"
      version = "3.2"
    },
    {
      type    = "Microsoft_BotManagerRuleSet"
      version = "1.0"
    }
  ]

  all_managed_rules = concat(local.predefined_managed_rules, var.managed_rules)
}

resource "azurerm_web_application_firewall_policy" "waf_policy" {
  name                = "${module.resource_name_prefix.resource_name}-waf-policy"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  dynamic "custom_rules" {
    for_each = var.custom_rules
    content {
      name      = custom_rules.value.name
      priority  = custom_rules.value.priority
      rule_type = custom_rules.value.rule_type
      action    = custom_rules.value.action
      match_conditions {
        match_variables {
          variable_name = custom_rules.value.match_variable_name
          selector      = custom_rules.value.match_variable_selector
        }
        operator           = custom_rules.value.condition_operator
        negation_condition = custom_rules.value.condition_negation
        match_values       = custom_rules.value.condition_match_values
      }
    }
  }

  managed_rules {
    dynamic "managed_rule_set" {
      for_each = local.all_managed_rules
      content {
        type    = managed_rule_set.value.type
        version = managed_rule_set.value.version
      }
    }
  }

  policy_settings {
    mode = "Prevention"
  }

  tags = var.tags
}


##########################
#       Logging          #
##########################
resource "azurerm_log_analytics_workspace" "workspace" {
  name                = "${module.resource_name_prefix.resource_name}-waf-log"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = "PerGB2018"
  tags                = var.tags
}

# resource "azurerm_monitor_diagnostic_setting" "waf_diagnostics" {
#   name                       = "${module.resource_name_prefix.resource_name}-waf-diagnostics"
#   target_resource_id         = azurerm_web_application_firewall_policy.waf_policy.id
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.id

#   log {
#     category = "FirewallPolicy"
#     enabled  = true

#     retention_policy {
#       days    = 30
#       enabled = true
#     }
#   }

#   metric {
#     category = "AllMetrics"
#     enabled  = true

#     retention_policy {
#       days    = 30
#       enabled = true
#     }
#   }
# tags = var.tags
# }