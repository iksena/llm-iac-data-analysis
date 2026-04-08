output "region" {
  description = "The AWS region this module resources resides in."
  value       = aws_quicksight_account_subscription.this.region
}

output "id" {
  description = "The ID of the QuickSight account."
  value       = aws_quicksight_account_subscription.this.id
}

output "name" {
  description = "The name of the QuickSight account."
  value       = aws_quicksight_account_subscription.this.account_name
}

output "edition" {
  description = "The edition of QuickSight."
  value       = aws_quicksight_account_subscription.this.edition
}

output "status" {
  description = "The subscription status of the QuickSight account."
  value       = aws_quicksight_account_subscription.this.account_subscription_status
}

output "notification_email" {
  description = "The notification email for the QuickSight account."
  value       = aws_quicksight_account_subscription.this.notification_email
}

output "default_namespace" {
  description = "The default namespace for the QuickSight account."
  value       = aws_quicksight_account_settings.this.default_namespace
}

output "termination_protection_enabled" {
  description = "Whether termination protection is enabled for the QuickSight account."
  value       = aws_quicksight_account_settings.this.termination_protection_enabled
}

output "authentication_method" {
  description = "The authentication method for the QuickSight account."
  value       = aws_quicksight_account_subscription.this.authentication_method
}

output "active_directory" {
  description = "The configuration for Active Directory authentication."
  value = (aws_quicksight_account_subscription.this.authentication_method == "ACTIVE_DIRECTORY"
    ? {
      name         = aws_quicksight_account_subscription.this.active_directory_name
      realm        = aws_quicksight_account_subscription.this.realm
      directory_id = aws_quicksight_account_subscription.this.directory_id
    }
    : null
  )
}

output "iam_identity_center" {
  description = "The configuration for IAM Identity Center authentication."
  value = (aws_quicksight_account_subscription.this.authentication_method == "IAM_IDENTITY_CENTER"
    ? {
      instance = aws_quicksight_account_subscription.this.iam_identity_center_instance_arn
    }
    : null
  )
}

output "role_memberships" {
  description = "The role memberships for the QuickSight account."
  value = (contains(["ACTIVE_DIRECTORY", "IAM_IDENTITY_CENTER"], var.authentication_method)
    ? {
      admin      = aws_quicksight_account_subscription.this.admin_group
      admin_pro  = aws_quicksight_account_subscription.this.admin_pro_group
      author     = aws_quicksight_account_subscription.this.author_group
      author_pro = aws_quicksight_account_subscription.this.author_pro_group
      reader     = aws_quicksight_account_subscription.this.reader_group
      read_pro   = aws_quicksight_account_subscription.this.reader_pro_group
    }
    : null
  )
}

# output "debug" {
#   value = {
#     subscription = {
#       for k, v in aws_quicksight_account_subscription.this :
#       k => v
#       if !contains(["account_name", "authentication_method", "edition", "aws_account_id", "notification_email", "timeouts", "contact_number", "email_address", "first_name", "last_name", "admin_group", "admin_pro_group", "author_group", "author_pro_group", "reader_group", "reader_pro_group", "id", "account_subscription_status", "iam_identity_center_instance_arn", "active_directory_name", "realm", "directory_id", "region"], k)
#     }
#     settings = {
#       for k, v in aws_quicksight_account_settings.this :
#       k => v
#       if !contains(["default_namespace", "termination_protection_enabled", "aws_account_id", "timeouts"], k)
#     }
#   }
# }
