module "AzureResourceTypes" {
  source = "../../modules/azure-resource-types"
}

module "ResourceTags" {
  source = "../../modules/resource-tags"
}

## Resource Group (e.g. rg-RemoteState-dev-eus2)
resource "azurerm_resource_group" "rgRemoteState" {
  name     = "${module.AzureResourceTypes.resource_type_resource_group}-Terraform-${var.resource_name_environment}-${var.resource_name_location}"
  location = var.azure_region
  tags = {
    Product     = module.ResourceTags.resource_tag_product_name
    Criticality = module.ResourceTags.resource_tag_criticality
    CostCenter  = "${module.ResourceTags.resource_tag_cost_center}-${var.resource_name_environment}"
    DR          = module.ResourceTags.resource_tag_dr
    Env         = var.resource_name_environment
  }
}

## Storage Account (e.g. stremotestatedeveus2)
resource "azurerm_storage_account" "stRemoteState" {
  name                            = "${lower(module.AzureResourceTypes.resource_type_storage_account)}terraform${lower(var.resource_name_environment)}${lower(var.resource_name_location)}"
  resource_group_name             = azurerm_resource_group.rgRemoteState.name
  location                        = azurerm_resource_group.rgRemoteState.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false

  tags = {
    Product     = module.ResourceTags.resource_tag_product_name
    Criticality = module.ResourceTags.resource_tag_criticality
    CostCenter  = "${module.ResourceTags.resource_tag_cost_center}-${var.resource_name_environment}"
    DR          = module.ResourceTags.resource_tag_dr
    Env         = var.resource_name_environment
  }
}

resource "azurerm_storage_container" "ctRemoteState" {
  name                 = "terraform-state"
  storage_account_name = azurerm_storage_account.stRemoteState.name
}

data "azurerm_storage_account_sas" "sasRemoteState" {
  connection_string = azurerm_storage_account.stRemoteState.primary_connection_string
  https_only        = true

  resource_types {
    service   = true
    container = true
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = timestamp()
  expiry = timeadd(timestamp(), "17520h")

  permissions {
    read    = true
    write   = true
    delete  = true
    list    = true
    add     = true
    create  = true
    update  = false
    process = false
    tag     = false
    filter  = false
  }
}

resource "local_file" "post-config" {
  depends_on = [azurerm_storage_container.ctRemoteState]

  filename = "${path.module}/backend-config.txt"
  content  = <<-EOF
storage_account_name = "${azurerm_storage_account.stRemoteState.name}"
container_name = "terraform-state"
key = "terraform.tfstate"
sas_token = "${data.azurerm_storage_account_sas.sasRemoteState.sas}"

  EOF
}


output "storage_account_name" {
  value = azurerm_storage_account.stRemoteState.name
}

output "resource_group_name" {
  value = azurerm_resource_group.rgRemoteState.name
}