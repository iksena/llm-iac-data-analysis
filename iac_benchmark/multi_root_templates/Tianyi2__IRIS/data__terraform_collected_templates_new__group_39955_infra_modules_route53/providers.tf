terraform {
  required_version = ">= 1.5.0"
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "3.4.5"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }
}
