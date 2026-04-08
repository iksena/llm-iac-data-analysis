terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "~> 3.0"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = "~> 2"
    }
    jinja = {
      source = "NikolaLohinski/jinja"
      version = "~> 2.0"
    }
  }

  required_version = "~> 1.14"
}
