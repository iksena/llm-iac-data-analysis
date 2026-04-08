terraform {
  required_version = ">= 1.2.8"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = ">= 3.1.1"
    }
    ibm = {
      source = "IBM-Cloud/ibm"
      version = ">= 1.48.0"
    }
  }
}
