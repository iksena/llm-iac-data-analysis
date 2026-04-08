
output "ccm_id" {
  value = module.roles.ccm_token_id
}
output "ccm_token" {
  sensitive = true
  value     = module.roles.ccm_token_secret
}

output "csi_id" {
  value = module.roles.csi_token_id
}
output "csi_token" {
  sensitive = true
  value     = module.roles.csi_token_secret
}

output "karpenter_id" {
  value = module.roles.karpenter_token_id
}

output "karpenter_token" {
  sensitive = true
  value     = module.roles.karpenter_token_secret
}
