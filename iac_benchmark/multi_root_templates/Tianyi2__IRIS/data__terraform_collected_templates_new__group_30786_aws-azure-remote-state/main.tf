terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      owner      = "efcunha"
      managed_by = "terraform"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}