# https://developer.hashicorp.com/terraform/language/settings
# https://developer.hashicorp.com/terraform/language/expressions/version-constraints

terraform {
  # Root modules should constraint both a lower and upper bound on versions for each provider.
  required_version = "~> 1.12"

  required_providers {
    # https://registry.terraform.io/providers/hashicorp/local/latest
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    # https://registry.terraform.io/providers/hashicorp/random/latest
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
    # https://registry.terraform.io/providers/hashicorp/tls/latest
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.1"
    }
    # https://registry.terraform.io/providers/vancluever/acme/latest
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.32"
    }
    # https://registry.terraform.io/providers/cloudflare/cloudflare/latest
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.6"
    }
    # https://registry.terraform.io/providers/hashicorp/aws/latest
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
