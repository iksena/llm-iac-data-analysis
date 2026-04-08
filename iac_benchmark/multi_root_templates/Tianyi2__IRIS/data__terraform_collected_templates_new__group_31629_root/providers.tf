terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "1.6.2"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }

    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }

    external = {
      source  = "hashicorp/external"
      version = "2.2.2"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }


    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.30.0"
    }
  }
}

