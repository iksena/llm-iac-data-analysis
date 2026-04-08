locals {
  metadata = {
    package = "terraform-aws-quicksight"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = var.name
  }
}

data "aws_caller_identity" "this" {}

locals {
  account_id = data.aws_caller_identity.this.account_id
}


###################################################
# QuickSight Group
###################################################

resource "aws_quicksight_group" "this" {
  count = var.type == "INTERNAL" ? 1 : 0

  region = var.region

  aws_account_id = local.account_id

  namespace   = var.namespace
  group_name  = var.name
  description = var.description
}

data "aws_quicksight_group" "this" {
  count = var.type == "EXTERNAL" ? 1 : 0

  region = var.region

  aws_account_id = local.account_id

  namespace  = var.namespace
  group_name = var.name
}

locals {
  group = var.type == "INTERNAL" ? aws_quicksight_group.this[0] : data.aws_quicksight_group.this[0]
}

resource "aws_quicksight_group_membership" "this" {
  for_each = toset(var.members)

  region = local.group.region

  aws_account_id = local.account_id

  namespace   = local.group.namespace
  group_name  = local.group.group_name
  member_name = each.value
}


###################################################
# QuickSight Role Membership
###################################################

resource "aws_quicksight_role_membership" "this" {
  count = var.role != "NONE" ? 1 : 0

  region = local.group.region

  aws_account_id = local.account_id

  namespace   = var.namespace
  member_name = local.group.group_name

  role = var.role
}
