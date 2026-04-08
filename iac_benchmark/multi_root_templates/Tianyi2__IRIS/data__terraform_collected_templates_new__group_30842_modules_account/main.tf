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
# QuickSight Account Subscription
###################################################

# INFO: Not supported attributes
# - `contact_number`
# - `email_address`
# - `first_name`
# - `last_name`
resource "aws_quicksight_account_subscription" "this" {
  region = var.region

  aws_account_id = local.account_id

  account_name = var.name
  edition      = var.edition

  notification_email = var.notification_email


  ### Authentication
  authentication_method = var.authentication_method

  ## Active Directory
  active_directory_name = (var.authentication_method == "ACTIVE_DIRECTORY" && var.active_directory != null
    ? var.active_directory.name
    : null
  )
  realm = (var.authentication_method == "ACTIVE_DIRECTORY" && var.active_directory != null
    ? var.active_directory.realm
    : null
  )
  directory_id = (var.authentication_method == "ACTIVE_DIRECTORY" && var.active_directory != null
    ? var.active_directory.directory_id
    : null
  )

  ## IAM Identity Center
  iam_identity_center_instance_arn = (var.authentication_method == "IAM_IDENTITY_CENTER" && var.iam_identity_center != null
    ? var.iam_identity_center.instance
    : null
  )

  ## Role Memberships
  admin_group = (contains(["ACTIVE_DIRECTORY", "IAM_IDENTITY_CENTER"], var.authentication_method)
    ? var.role_memberships.admin
    : null
  )
  admin_pro_group = (contains(["ACTIVE_DIRECTORY", "IAM_IDENTITY_CENTER"], var.authentication_method) && length(var.role_memberships.admin_pro) > 0
    ? var.role_memberships.admin_pro
    : null
  )
  author_group = (contains(["ACTIVE_DIRECTORY", "IAM_IDENTITY_CENTER"], var.authentication_method) && length(var.role_memberships.author) > 0
    ? var.role_memberships.author
    : null
  )
  author_pro_group = (contains(["ACTIVE_DIRECTORY", "IAM_IDENTITY_CENTER"], var.authentication_method) && length(var.role_memberships.author_pro) > 0
    ? var.role_memberships.author_pro
    : null
  )
  reader_group = (contains(["ACTIVE_DIRECTORY", "IAM_IDENTITY_CENTER"], var.authentication_method) && length(var.role_memberships.reader) > 0
    ? var.role_memberships.reader
    : null
  )
  reader_pro_group = (contains(["ACTIVE_DIRECTORY", "IAM_IDENTITY_CENTER"], var.authentication_method) && length(var.role_memberships.reader_pro) > 0
    ? var.role_memberships.reader_pro
    : null
  )

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }

  lifecycle {
    ignore_changes = [
      # INFO: Prevents recreation due to provider issue
      admin_group,
      authentication_method,
      aws_account_id,
    ]
  }
}


###################################################
# QuickSight Account Settings
###################################################

# TODO: Support `region` argument when supported by the provider
resource "aws_quicksight_account_settings" "this" {
  aws_account_id = aws_quicksight_account_subscription.this.aws_account_id

  default_namespace              = var.default_namespace
  termination_protection_enabled = var.termination_protection_enabled
}
