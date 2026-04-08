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

data "aws_subnet" "selected" {
  region = var.region

  id = var.subnets[0]
}

locals {
  account_id = data.aws_caller_identity.this.account_id
  vpc_id     = data.aws_subnet.selected.vpc_id
}


###################################################
# QuickSight VPC Connection
###################################################

resource "aws_quicksight_vpc_connection" "this" {
  region = var.region

  aws_account_id = local.account_id

  vpc_connection_id = var.name
  name              = coalesce(var.display_name, var.name)
  role_arn          = local.execution_role


  ## Network
  subnet_ids         = var.subnets
  security_group_ids = local.security_groups
  dns_resolvers = (length(var.dns_resolvers) > 0
    ? var.dns_resolvers
    : null
  )

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )

  # INFO: Provider produced inconsistent result after apply
  # timeouts {
  #   create = var.timeouts.create
  #   update = var.timeouts.update
  #   delete = var.timeouts.delete
  # }
}
