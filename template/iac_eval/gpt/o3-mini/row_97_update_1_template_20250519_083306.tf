provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "client_id" {
  description = "The client ID for the OIDC configuration"
  type        = string
  default     = "my-oidc-client-id"
}

variable "issuer_url" {
  description = "The issuer URL for the OIDC configuration"
  type        = string
  default     = "https://example.com/oidc"
}

variable "identity_provider_config_name" {
  description = "The name for the OIDC identity provider configuration"
  type        = string
  default     = "example-oidc-config"
}

resource "aws_eks_identity_provider_config" "example_oidc" {
  cluster_name                  = "example"  // referencing the cluster by its name
  identity_provider_config_name = var.identity_provider_config_name
  type                          = "oidc"

  oidc {
    client_id  = var.client_id
    issuer_url = var.issuer_url
  }
}