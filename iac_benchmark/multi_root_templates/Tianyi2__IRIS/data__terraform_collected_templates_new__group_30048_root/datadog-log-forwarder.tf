resource "random_string" "id" {
  length = 5
  upper  = false
  special = false
}

#######################
# Pre-requisites
#######################

module "prerequisites" {
    source = "./modules/prerequisites"
    resource_group_name = format("rg-dd-log-forwarder-%s", random_string.id.result)
    location = var.location
    storage_account_name = format("stddlogforwarder%s", random_string.id.result)
    vnet_name = format("vnet-dd-log-forwarder-%s", random_string.id.result)
    vnet_address_space = ["10.0.0.0/23"]
    snet_001_name = format("snet-001-dd-log-forwarder-%s", random_string.id.result)
    snet_001_prefixes = ["10.0.0.0/27"]
    snet_002_name = format("snet-002-dd-log-forwarder-%s", random_string.id.result)
    snet_002_prefixes = ["10.0.0.32/27"]
}

########################
# Log Forwarder Setup
########################

# Event hub to collect Azure resource logs
module "eventhub" {
    source = "./modules/event-hub"
    resource_group_name = module.prerequisites.resource_group_name
    location = var.location
    event_hub_namespace_name = format("ehns-dd-log-forwarder-%s", random_string.id.result)
    event_hub_name = format("eh-dd-log-forwarder-%s", random_string.id.result)
    vnet_id = module.prerequisites.vnet_id
    subnet_id = module.prerequisites.snet_001_id
}

# Azure functions to forward logs to Datadog
module "function" {
    source = "./modules/function-app"
    resource_group_name = module.prerequisites.resource_group_name
    location = var.location
    app_service_plan_name = format("asp-dd-log-forwarder-%s", random_string.id.result)
    function_app_name = format("fa-dd-log-forwarder-%s", random_string.id.result)
    event_hub_namespace_name = module.eventhub.event_hub_namespace_name
    event_hub_namespace_id = module.eventhub.event_hub_namespace_id
    event_hub_name = module.eventhub.event_hub_name
    datadog_api_key = var.datadog_api_key
    datadog_site = "datadoghq.com"
    storage_account_name = module.prerequisites.storage_account_name
    storage_account_id = module.prerequisites.storage_account_id
    vnet_id = module.prerequisites.vnet_id
    fa_outbound_subnet_id = module.prerequisites.snet_002_id
    fa_pep_subnet_id = module.prerequisites.snet_001_id
}

#########################################
# TODO: Example Usage with Diagnostic Settings
#########################################