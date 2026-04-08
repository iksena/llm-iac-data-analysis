terraform {
  required_version = ">= 0.13.0"

  required_providers {
    spotinst = {
      source  = "spotinst/spotinst"
      version = "~> 1.81.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.55"
    }
  }
}
