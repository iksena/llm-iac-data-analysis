terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    twilio = {
      source  = "RJPearson94/twilio"
      version = "0.26.1"
    }
  }
}

provider "twilio" {
  account_sid = var.twilio_account_sid
  api_key     = var.twilio_api_key
  api_secret  = var.twilio_api_secret
}
