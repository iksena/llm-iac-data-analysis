# ── variables.tf ────────────────────────────────────
variable "az_identity_name" {
  type        = string
  description = "(Required) Name of application and service principal."
}

variable "az_owner_id" {
  type        = string
  description = "(Optional) Object ID of owner to be assigned to service principal. Assigned to current user if not set."
  default     = null
}

variable "az_subscription_id" {
  type        = string
  description = "(Optional) Subscription ID service principal with received Contributor permissions on. Assigned to current subscription if not set."
  default     = null
}

variable "tfc_hostname" {
  type        = string
  description = "(Optional) Hostname of Terraform Cloud instance. Defaults to app.terraform.io."
  default     = "app.terraform.io"
}

variable "tfc_organization_name" {
  type        = string
  description = "(Required) Name of the Terraform Cloud organization."
}

variable "tfc_project_name" {
  type        = string
  description = "(Required) Name of the Terraform Cloud project."
}

variable "tfc_workspace_name" {
  type        = string
  description = "(Required) Name of the Terraform Cloud workspace."
}

# ── azure.tf ────────────────────────────────────
# Providers
provider "azurerm" {
  features {

  }
}

provider "azuread" {

}

# Create the necessary resources for the Dynamic Identity
# Create an application
resource "azuread_application" "oidc" {
  display_name = var.az_identity_name
}

# Create a federated identity credential for plan and apply

resource "azuread_application_federated_identity_credential" "oidc" {
  for_each              = toset(["plan", "apply"])
  application_object_id = azuread_application.oidc.object_id
  display_name          = "${azuread_application.oidc.display_name}-${each.key}"
  description           = "Terraform Cloud credential to run ${each.key} phase on ${var.tfc_organization_name}/${var.tfc_project_name}/${var.tfc_workspace_name}."
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = "https://${var.tfc_hostname}"
  subject               = "organization:${var.tfc_organization_name}:project:${var.tfc_project_name}:workspace:${var.tfc_workspace_name}:run_phase:${each.key}"
}

# Create a service principal
data "azuread_client_config" "current" {}

locals {
  owner_id = var.az_owner_id != null ? var.az_owner_id : data.azuread_client_config.current.object_id
}

resource "azuread_service_principal" "oidc" {
  application_id = azuread_application.oidc.application_id
  owners         = [local.owner_id]
}

# Grant the service principal Contributor permissions on the subscription
data "azurerm_subscription" "current" {}

locals {
  subscription_id = var.az_subscription_id != null ? var.az_subscription_id : data.azurerm_subscription.current.id
}

resource "azurerm_role_assignment" "main" {
  scope                = local.subscription_id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.oidc.object_id
}

# ── terraform.tf ────────────────────────────────────
terraform {
  required_version = "~> 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~>0.0"
    }
  }
}

# ── tfc.tf ────────────────────────────────────
# Terraform Cloud Provider
provider "tfe" {
  hostname     = var.tfc_hostname
  organization = var.tfc_organization_name
}

# Create project
resource "tfe_project" "main" {
  name = var.tfc_project_name
}

# Create workspace
resource "tfe_workspace" "main" {
  name        = var.tfc_workspace_name
  project_id  = tfe_project.main.id
  description = "Test workspace for Dynamic Identity"
  auto_apply  = true
}

# Configure workspace variables
resource "tfe_variable" "azure_auth" {
  description  = "Enable Dynamic Identity for Azure"
  workspace_id = tfe_workspace.main.id
  key          = "TFC_AZURE_PROVIDER_AUTH"
  value        = "true"
  category     = "env"
}

resource "tfe_variable" "client_id" {
  description  = "Azure Client ID for Dynamic Identity"
  workspace_id = tfe_workspace.main.id
  key          = "TFC_AZURE_RUN_CLIENT_ID"
  value        = azuread_application.oidc.application_id
  category     = "env"
}

resource "tfe_variable" "tenant_id" {
  description  = "Azure Tenant ID for Dynamic Identity"
  workspace_id = tfe_workspace.main.id
  key          = "ARM_TENANT_ID"
  value        = data.azurerm_subscription.current.tenant_id
  category     = "env"
}

resource "tfe_variable" "subscription_id" {
  description  = "Azure Subscription ID for Dynamic Identity"
  workspace_id = tfe_workspace.main.id
  key          = "ARM_SUBSCRIPTION_ID"
  value        = data.azurerm_subscription.current.subscription_id
  category     = "env"
}