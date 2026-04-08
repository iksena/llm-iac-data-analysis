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
# QuickSight User
###################################################

# INFO: Not supported attributes
# - `iam_arn`
# - `session_name`
resource "aws_quicksight_user" "this" {
  count = var.type == "INTERNAL" ? 1 : 0

  region = var.region

  aws_account_id = local.account_id

  # INFO: Not support `IAM` identity type in this module
  identity_type = "QUICKSIGHT"
  namespace     = var.namespace
  user_name     = var.name

  email     = var.email
  user_role = var.role
}

data "aws_quicksight_user" "this" {
  count = var.type == "EXTERNAL" ? 1 : 0

  region = var.region

  aws_account_id = local.account_id

  namespace = var.namespace
  user_name = var.name
}

locals {
  user = var.type == "INTERNAL" ? aws_quicksight_user.this[0] : data.aws_quicksight_user.this[0]
}
