# ── variables.tf ────────────────────────────────────


# ── outputs.tf ────────────────────────────────────
output "role_id" {
  value = vault_approle_auth_backend_role.tfc_dev.role_id
}

output "secret_id" {
  value = nonsensitive(vault_approle_auth_backend_role_secret_id.tfc_dev.secret_id)
}

output "role_path" {
  value = vault_auth_backend.approle.path
}


# ── versions.tf ────────────────────────────────────
terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~>3.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.0"
    }

    azurerm = {
        source  = "hashicorp/azurerm"
        version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}


# ── app_role.tf ────────────────────────────────────
resource "vault_auth_backend" "approle" {
  type = "approle"
  path = "tfc-approle"
}

resource "vault_policy" "example" {
  name = "dev"

  policy = <<EOT
path "azure-dev/" {
  capabilities = ["read","list"]
}

path "azure-dev/*" {
  capabilities = ["read","list"]
}

path "auth/token/create" {
  capabilities = ["update"]
}
EOT
}

resource "vault_approle_auth_backend_role" "tfc_dev" {
  backend        = vault_auth_backend.approle.path
  role_name      = "dev-role"
  token_policies = ["default", "dev"]
}

resource "vault_approle_auth_backend_role_secret_id" "tfc_dev" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.tfc_dev.role_name
}

## Configure an Azure Secrets Manager
data "azurerm_subscription" "current" {}

resource "vault_azure_secret_backend" "tfc_dev" {
  path = "azure-dev"
  use_microsoft_graph_api = true
  subscription_id         = data.azurerm_subscription.current.subscription_id
  tenant_id               = data.azuread_client_config.current.tenant_id
  client_id               = azuread_service_principal.vault_tfc.application_id
  client_secret           = azuread_service_principal_password.vault_tfc.value
  environment             = "AzurePublicCloud"
}

resource "vault_azure_secret_backend_role" "dev_role" {
  backend = vault_azure_secret_backend.tfc_dev.path
  role = "dev-role"
  ttl = 300
  max_ttl = 600

  azure_roles {
    role_name = "Contributor"
    scope = "${data.azurerm_subscription.current.id}"
  }

  depends_on = [
    azurerm_role_assignment.dev_subscription
  ]
}

# ── azure_config.tf ────────────────────────────────────
# We are going to create a service principal for the vault to use.

data "azuread_client_config" "current" {}

data "azuread_application_published_app_ids" "well_known" {}

locals {
  application_permissions = [
    "Application.Read.All",
    "Application.ReadWrite.All",
    "Application.ReadWrite.OwnedBy",
    "Directory.Read.All",
    "Directory.ReadWrite.All",
    "Group.Read.All",
    "Group.ReadWrite.All",
    "GroupMember.Read.All",
    "GroupMember.ReadWrite.All"
  ]
}

resource "azuread_service_principal" "msgraph" {
  application_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
  use_existing   = true
}

resource "azuread_application" "vault_tfc" {
  display_name = "vault-tfc"
  owners       = [data.azuread_client_config.current.object_id]

  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph

    dynamic "resource_access" {
      for_each = toset(local.application_permissions)

      content {
        id   = azuread_service_principal.msgraph.app_role_ids[resource_access.value]
        type = "Role"
      }
    }
  }
}

resource "azuread_service_principal" "vault_tfc" {
  application_id = azuread_application.vault_tfc.application_id
  owners         = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "vault_tfc" {
  service_principal_id = azuread_service_principal.vault_tfc.object_id
}

resource "azuread_app_role_assignment" "vault_tfc" {
  for_each            = toset(local.application_permissions)
  app_role_id         = azuread_service_principal.msgraph.app_role_ids[each.value]
  principal_object_id = azuread_service_principal.vault_tfc.object_id
  resource_object_id  = azuread_service_principal.msgraph.object_id
}

resource "azurerm_role_assignment" "dev_subscription" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner"
  principal_id         = azuread_service_principal.vault_tfc.object_id
}

