resource "aws_quicksight_key_registration" "this" {
  aws_account_id = var.aws_account_id
  region         = var.region

  dynamic "key_registration" {
    for_each = var.key_registration
    content {
      default_key = key_registration.value.default_key
      key_arn     = key_registration.value.key_arn
    }
  }
}