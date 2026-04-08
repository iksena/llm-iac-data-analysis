resource "aws_quicksight_account_subscription" "this" {
  account_name          = var.account_name
  authentication_method = var.authentication_method
  edition               = var.edition
  notification_email    = var.notification_email

  active_directory_name            = var.active_directory_name
  admin_group                      = var.admin_group
  author_group                     = var.author_group
  aws_account_id                   = var.aws_account_id
  contact_number                   = var.contact_number
  directory_id                     = var.directory_id
  email_address                    = var.email_address
  first_name                       = var.first_name
  iam_identity_center_instance_arn = var.iam_identity_center_instance_arn
  last_name                        = var.last_name
  reader_group                     = var.reader_group
  realm                            = var.realm
  region                           = var.region

  timeouts {
    create = var.timeouts_create
    delete = var.timeouts_delete
  }
}