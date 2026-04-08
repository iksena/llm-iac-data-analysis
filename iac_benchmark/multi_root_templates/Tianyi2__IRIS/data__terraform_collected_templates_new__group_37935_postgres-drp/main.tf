# Configure providers
terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = ">= 3.22.0"
        }

        azapi = {
            source = "azure/azapi"
            version = ">= 0.5.0"
        }

        random = {
        source  = "hashicorp/random"
        version = ">= 3.4.0"
        }
    }

    backend "azurerm" {
        resource_group_name  = "xxxxxxxxxxxxxxx" # prerequisite for storaging tfstate
        storage_account_name = "xxxxxxxxxxxxxxx" # prerequisite for storaging tfstate                     
        container_name       = "sample"                      
        key                  = "sample.terraform.tfstate"        
    }
}

provider "azurerm" {
    subscription_id = var.subscription_id
    features {}
}