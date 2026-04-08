resource "aws_eks_identity_provider_config" "this" {
  region       = var.region
  cluster_name = var.cluster_name

  oidc {
    client_id                     = var.oidc_client_id
    groups_claim                  = var.oidc_groups_claim
    groups_prefix                 = var.oidc_groups_prefix
    identity_provider_config_name = var.oidc_identity_provider_config_name
    issuer_url                    = var.oidc_issuer_url
    required_claims               = var.oidc_required_claims
    username_claim                = var.oidc_username_claim
    username_prefix               = var.oidc_username_prefix
  }

  tags = var.tags

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}