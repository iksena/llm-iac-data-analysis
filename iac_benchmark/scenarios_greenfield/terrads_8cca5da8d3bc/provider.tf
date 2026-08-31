terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.55.0"
    }
    acme = {
      source  = "vancluever/acme"
      version = "2.23.2"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# provider "acme" {
#   # Configuration options
#   #server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
#   #generates untrusted certs
#   server_url = "https://acme-v02.api.letsencrypt.org/directory"
# }