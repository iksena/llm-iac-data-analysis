locals {
  metadata = {
    package = "terraform-aws-quicksight"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = var.name
  }
  module_tags = var.module_tags_enabled ? {
    "module.terraform.io/package"   = local.metadata.package
    "module.terraform.io/version"   = local.metadata.version
    "module.terraform.io/name"      = local.metadata.module
    "module.terraform.io/full-name" = "${local.metadata.package}/${local.metadata.module}"
    "module.terraform.io/instance"  = local.metadata.name
  } : {}
}

data "aws_caller_identity" "this" {}

locals {
  account_id = data.aws_caller_identity.this.account_id
}


###################################################
# QuickSight Namespace
###################################################

# INFO: Not supported attributes
# - `aws_account_id`
resource "aws_quicksight_namespace" "this" {
  region = var.region

  aws_account_id = local.account_id

  namespace      = var.name
  identity_store = var.identity_store

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )
}
