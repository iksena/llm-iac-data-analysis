# ── main.tf ────────────────────────────────────
provider "azurerm" {
  features {}

}

ephemeral "azurerm_key_vault_secret" "k8s" {
  for_each = toset(["client-certificate", "client-key", "cluster-ca-certificate"])

  name         = each.key
  key_vault_id = var.key_vault_id
}

provider "kubernetes" {
  host = "https://${var.aks_cluster_host}"

  client_certificate     = base64decode(ephemeral.azurerm_key_vault_secret.k8s["client-certificate"].value)
  client_key             = base64decode(ephemeral.azurerm_key_vault_secret.k8s["client-key"].value)
  cluster_ca_certificate = base64decode(ephemeral.azurerm_key_vault_secret.k8s["cluster-ca-certificate"].value)
}


resource "kubernetes_namespace" "example" {
  metadata {
    annotations = {
      name = "example-annotation"
    }

    labels = {
      mylabel = "label-value"
    }

    name = "terraform-example-namespace"
  }
}

# ── variables.tf ────────────────────────────────────
variable "aks_cluster_host" {
  description = "The Kubernetes cluster host."
  type        = string
}

variable "key_vault_id" {
  description = "The ID of the Azure Key Vault."
  type        = string

}

# ── terraform.tf ────────────────────────────────────
terraform {
  required_version = ">= 1.10"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.11"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.0"
    }
  }
}