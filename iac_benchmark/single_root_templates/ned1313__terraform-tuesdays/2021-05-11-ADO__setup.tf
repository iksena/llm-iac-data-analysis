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
  default     = "2021-05-11-ADO/vnet/azure-pipelines.yaml"
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

variable "az_client_id" {
  type        = string
  description = "Client ID with permissions to create resources in Azure, use env variables"
}

variable "az_client_secret" {
  type        = string
  description = "Client secret with permissions to create resources in Azure, use env variables"
}

variable "az_subscription" {
  type        = string
  description = "Client ID subscription, use env variables"
}

variable "az_tenant" {
  type        = string
  description = "Client ID Azure AD tenant, use env variables"
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

}

# ── azuread.tf ────────────────────────────────────
# The pipeline needs a service principal to use for an AzureRM service connection
# It will need access to the Azure Key Vault

# You also need a service principal to use for creating resources in an AzureRM sub

# I don't think those should be the same SP. The KV might be in a different sub than the place
# you want to create resources. So we'll create two SPs.

# Create SP for service connection in pipeline. Will be used to access KV.

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
    name  = "storageaccount"
    value = azurerm_storage_account.sa.name
  }

  variable {
    name  = "container_name"
    value = var.az_container_name
  }

  variable {
    name  = "key"
    value = var.az_state_key
  }

  variable {
    name         = "sas_token"
    secret_value = data.azurerm_storage_account_sas.state.sas
    is_secret    = true
  }

  variable {
    name         = "az_client_id"
    secret_value = var.az_client_id
    is_secret    = true
  }

  variable {
    name         = "az_client_secret"
    secret_value = var.az_client_secret
    is_secret    = true
  }

  variable {
    name         = "az_subscription"
    secret_value = var.az_subscription
    is_secret    = true
  }

  variable {
    name         = "az_tenant"
    secret_value = var.az_tenant
    is_secret    = true
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

# Key Vault task is here: https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/deploy/azure-key-vault?view=azure-devops



# ── azurekeyvault.tf ────────────────────────────────────


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