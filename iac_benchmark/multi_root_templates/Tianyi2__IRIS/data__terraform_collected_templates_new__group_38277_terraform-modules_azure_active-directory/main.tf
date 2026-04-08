######################################
#     Naming and tagging Config      #
######################################
module "tags" {
  #checkov:skip=CKV_TF_1:Versions are used instead of commit hashes
  source = "git@github.com:UKHSA-Internal/devops-terraform-modules.git//terraform-modules/helpers/tags?ref=TF/helpers/tags/vALPHA_0.0.6"

  project         = var.tags.project
  client          = var.tags.client
  owner           = var.tags.owner
  environment     = var.tags.environment
  additional_tags = var.tags.additional_tags != null ? var.tags.additional_tags : {}
}

module "resource_name_prefix" {
  #checkov:skip=CKV_TF_1:Versions are used instead of commit hashes
  source = "git@github.com:UKHSA-Internal/devops-terraform-modules.git//terraform-modules/helpers/resource-name-prefix?ref=TF/helpers/resource-name-prefix/vALPHA_0.0.2"

  name = var.b2c_display_name
  tags = module.tags.tags
}

######################################
#     Azure Active Directory B2C     #
######################################
resource "azurerm_aadb2c_directory" "azure_b2c" {
  domain_name             = var.b2c_domain_name
  country_code            = var.country_code
  data_residency_location = var.data_residency_location
  display_name            = "${module.resource_name_prefix.resource_name}-aad-b2c"
  resource_group_name     = var.resource_group_name
  sku_name                = var.b2c_sku
  tags                    = merge(var.aadb2c_tags, module.tags.tags)
}
