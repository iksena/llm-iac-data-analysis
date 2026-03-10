# ── main.tf ────────────────────────────────────
resource "azapi_resource" "res-0" {
  body = jsonencode({
    kind = "StorageV2"
    properties = {
      accessTier                   = "Hot"
      allowBlobPublicAccess        = true
      allowCrossTenantReplication  = true
      allowSharedKeyAccess         = true
      defaultToOAuthAuthentication = false
      encryption = {
        keySource = "Microsoft.Storage"
        services = {
          blob = {
            enabled = true
            keyType = "Account"
          }
          file = {
            enabled = true
            keyType = "Account"
          }
        }
      }
      isHnsEnabled      = false
      isNfsV3Enabled    = false
      isSftpEnabled     = false
      minimumTlsVersion = "TLS1_2"
      networkAcls = {
        bypass              = "AzureServices"
        defaultAction       = "Allow"
        ipRules             = []
        virtualNetworkRules = []
      }
      publicNetworkAccess      = "Enabled"
      supportsHttpsTrafficOnly = true
    }
    sku = {
      name = "Standard_LRS"
    }
  })
  location  = "eastus"
  name      = "tacotruckc997e06f"
  parent_id = "/subscriptions/4d8e572a-3214-40e9-a26f-8f71ecd24e0d/resourceGroups/tacotruck-vms"
  type      = "Microsoft.Storage/storageAccounts@2023-01-01"
  identity {
    identity_ids = []
    type         = "None"
  }
}


# ── import.tf ────────────────────────────────────
import {
  id = "/subscriptions/4d8e572a-3214-40e9-a26f-8f71ecd24e0d/resourceGroups/tacotruck-vms/providers/Microsoft.Storage/storageAccounts/tacotruckc997e06f"
  to = azapi_resource.res-0
}


# ── provider.tf ────────────────────────────────────
provider "azapi" {
}


# ── terraform.tf ────────────────────────────────────
terraform {
  backend "local" {}

  required_providers {
    azapi = {
      source = "azure/azapi"
      version = "1.9.0"

    }
  }
}
