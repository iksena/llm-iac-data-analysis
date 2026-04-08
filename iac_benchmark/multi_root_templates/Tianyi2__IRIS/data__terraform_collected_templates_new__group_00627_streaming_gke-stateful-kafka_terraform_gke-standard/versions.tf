terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "< 5.0" # upgrade to ~> 5.0 *AFTER* terraform-google-network module is updated (https://github.com/terraform-google-modules/terraform-google-network/pull/506)
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
  required_version = ">= 0.13"
}
