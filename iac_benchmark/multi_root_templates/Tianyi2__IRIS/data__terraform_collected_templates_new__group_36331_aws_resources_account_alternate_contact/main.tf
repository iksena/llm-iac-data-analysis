resource "aws_account_alternate_contact" "this" {
  account_id             = var.account_id
  alternate_contact_type = var.alternate_contact_type
  email_address          = var.email_address
  name                   = var.name
  phone_number           = var.phone_number
  title                  = var.title

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}