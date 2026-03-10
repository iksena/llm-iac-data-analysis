# ── variables.tf ────────────────────────────────────
variable "ado_org_service_url" {
  type        = string
  description = "Org service url for Azure DevOps"
}

variable "ado_github_repo" {
  type        = string
  description = "Name of the repository in the format <GitHub Org>/<RepoName>"
  default     = "ned1313/terraform-tuesdays"
}

variable "ado_pipeline_yaml_path_1" {
  type        = string
  description = "Path to the yaml for the first pipeline"
  default     = "2021-06-22-ADO/vnet/azure-pipelines.yaml"
}

variable "ado_github_pat" {
  type        = string
  description = "Personal authentication token for GitHub repo"
  sensitive   = true
}

variable "prefix" {
  type        = string
  description = "Naming prefix for resources"
  default     = "tacos"
}

variable "az_location" {
  type    = string
  default = "eastus"
}

variable "az_container_name" {
  type        = string
  description = "Name of container on storage account for Terraform state"
  default     = "terraform-state"
}

variable "az_state_key" {
  type        = string
  description = "Name of key in storage account for Terraform state"
  default     = "terraform.tfstate"
}

resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}

locals {
  ado_project_name        = "${var.prefix}-project-${random_integer.suffix.result}"
  ado_project_description = "Project for ${var.prefix}"
  ado_project_visibility  = "private"
  ado_pipeline_name_1     = "${var.prefix}-pipeline-1"

  az_resource_group_name  = "${var.prefix}${random_integer.suffix.result}"
  az_storage_account_name = "${lower(var.prefix)}${random_integer.suffix.result}"
  az_key_vault_name = "${var.prefix}${random_integer.suffix.result}"

  pipeline_variables = {
    storageaccount = azurerm_storage_account.sa.name
    container-name = var.az_container_name
    key = var.az_state_key
    sas-token = data.azurerm_storage_account_sas.state.sas
    az-client-id = azuread_application.resource_creation.application_id
    az-client-secret = random_password.resource_creation.result
    az-subscription = data.azurerm_client_config.current.subscription_id
    az-tenant = data.azurerm_client_config.current.tenant_id
  }

  azad_service_connection_sp_name = "${var.prefix}-service-connection-${random_integer.suffix.result}"
  azad_resource_creation_sp_name = "${var.prefix}-resource-creation-${random_integer.suffix.result}"
}

# ── azuread.tf ────────────────────────────────────
# The pipeline needs a service principal to use for an AzureRM service connection
# It will need access to the Azure Key Vault

# You also need a service principal to use for creating resources in an AzureRM sub

# I don't think those should be the same SP. The KV might be in a different sub than the place
# you want to create resources. So we'll create two SPs.

# Create SP for service connection in pipeline. Will be used to access KV.

resource "azuread_application" "service_connection" {
  display_name               = local.azad_service_connection_sp_name
}

resource "azuread_service_principal" "service_connection" {
  application_id               = azuread_application.service_connection.application_id
}

resource "random_password" "service_connection" {
  length = 16
}

resource "azuread_service_principal_password" "service_connection" {
  service_principal_id = azuread_service_principal.service_connection.object_id
  value = random_password.service_connection.result
}

# Create SP for creation of Azure resources in selected subscription.
# These credentials will be written to the Key Vault and retrieved during pipeline run

resource "azuread_application" "resource_creation" {
  display_name               = local.azad_resource_creation_sp_name
}

resource "azuread_service_principal" "resource_creation" {
  application_id               = azuread_application.resource_creation.application_id
}

resource "random_password" "resource_creation" {
  length = 16
}

resource "azuread_service_principal_password" "resource_creation" {
  service_principal_id = azuread_service_principal.resource_creation.object_id
  value = random_password.resource_creation.result
}

resource "azurerm_role_assignment" "resource_creation" {
  scope = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id = azuread_service_principal.resource_creation.object_id
}


# ── azuredevops.tf ────────────────────────────────────
# Create ADO objects for pipeline

provider "azuredevops" {
  org_service_url = var.ado_org_service_url
  # Authentication through PAT defined with AZDO_PERSONAL_ACCESS_TOKEN 
}

resource "azuredevops_project" "project" {
  name               = local.ado_project_name
  description        = local.ado_project_description
  visibility         = local.ado_project_visibility
  version_control    = "Git"   # This will always be Git for me
  work_item_template = "Agile" # Not sure if this matters, check back later

  features = {
    # Only enable pipelines for now
    "testplans"    = "disabled"
    "artifacts"    = "disabled"
    "boards"       = "disabled"
    "repositories" = "disabled"
    "pipelines"    = "enabled"
  }
}


resource "azuredevops_serviceendpoint_github" "serviceendpoint_github" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "terraform-tuesdays"

  auth_personal {
    personal_access_token = var.ado_github_pat
  }
}

resource "azuredevops_resource_authorization" "auth" {
  project_id  = azuredevops_project.project.id
  resource_id = azuredevops_serviceendpoint_github.serviceendpoint_github.id
  authorized  = true
}

resource "azuredevops_variable_group" "variablegroup" {
  project_id   = azuredevops_project.project.id
  name         = "terraform-tuesdays"
  description  = "Variable group for pipelines"
  allow_access = true

  variable {
    name  = "service_name"
    value = "key_vault"
  }

  variable {
    name = "key_vault_name"
    value = local.az_key_vault_name
  }

}

resource "azuredevops_build_definition" "pipeline_1" {

  depends_on = [azuredevops_resource_authorization.auth]
  project_id = azuredevops_project.project.id
  name       = local.ado_pipeline_name_1

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type             = "GitHub"
    repo_id               = var.ado_github_repo
    branch_name           = "main"
    yml_path              = var.ado_pipeline_yaml_path_1
    service_connection_id = azuredevops_serviceendpoint_github.serviceendpoint_github.id
  }

}

# Key Vault setup
## There needs to be a service connection to an Azure sub with the key vault
## https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/serviceendpoint_azurerm

resource "azuredevops_serviceendpoint_azurerm" "key_vault" {
  project_id = azuredevops_project.project.id
  service_endpoint_name = "key_vault"
  description = "Azure Service Endpoint for Key Vault Access"

  credentials {
    serviceprincipalid = azuread_application.service_connection.application_id
    serviceprincipalkey = random_password.service_connection.result
  }

  azurerm_spn_tenantid = data.azurerm_client_config.current.tenant_id
  azurerm_subscription_id = data.azurerm_client_config.current.subscription_id
  azurerm_subscription_name = data.azurerm_subscription.current.display_name
}

resource "azuredevops_resource_authorization" "kv_auth" {
  project_id  = azuredevops_project.project.id
  resource_id = azuredevops_serviceendpoint_azurerm.key_vault.id
  authorized  = true
}

# Key Vault task is here: https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/deploy/azure-key-vault?view=azure-devops



# ── azurekeyvault.tf ────────────────────────────────────
data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

# Create a Key Vault
resource "azurerm_key_vault" "setup" {
  name = local.az_key_vault_name
  location = azurerm_resource_group.setup.location
  resource_group_name = azurerm_resource_group.setup.name
  tenant_id = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"
}

# Set access policies
# Grant yourself full access (probably could be restricted to just secret_permissions)
resource "azurerm_key_vault_access_policy" "you" {
  key_vault_id = azurerm_key_vault.setup.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  key_permissions = [
    "get", "list", "update", "create", "decrypt", "encrypt", "unwrapKey", "wrapKey", "verify", "sign",
  ]

  secret_permissions = [
    "get", "list", "set", "delete", "purge", "recover", "backup"
  ]

  certificate_permissions = [
    "get", "list", "create", "import", "delete", "update",
  ]
}

# Grant the pipeline SP access to [get,list] secrets from the KV
resource "azurerm_key_vault_access_policy" "pipeline" {
  key_vault_id = azurerm_key_vault.setup.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azuread_service_principal.service_connection.object_id

  secret_permissions = [
    "get", "list",
  ]

}

# Populate with secrets to be used by the pipeline
resource "azurerm_key_vault_secret" "pipeline" {
  depends_on = [
    azurerm_key_vault_access_policy.you
  ]
  for_each = local.pipeline_variables
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.setup.id
}


# ── azurestorage.tf ────────────────────────────────────
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "setup" {
  name     = local.az_resource_group_name
  location = var.az_location
}

resource "azurerm_storage_account" "sa" {
  name                     = local.az_storage_account_name
  resource_group_name      = azurerm_resource_group.setup.name
  location                 = var.az_location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

resource "azurerm_storage_container" "ct" {
  name                 = "terraform-state"
  storage_account_name = azurerm_storage_account.sa.name

}

data "azurerm_storage_account_sas" "state" {
  connection_string = azurerm_storage_account.sa.primary_connection_string
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
  }
}

# ── terraform.tf ────────────────────────────────────
terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.1.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"

    }

    azuread = {
      source = "hashicorp/azuread"
      version = "~> 1.0"
    }

  }
  backend "remote" {
    organization = "ned-in-the-cloud"

    workspaces {
      name = "terraform-tuesday-ado-setup"
    }
  }
}