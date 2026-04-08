terraform {
  required_version = ">= 1.14.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.45.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 6.45.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.10"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.38.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.4"
    }
  }
}
