resource "aws_appstream_directory_config" "this" {
  directory_name                          = var.directory_name
  organizational_unit_distinguished_names = var.organizational_unit_distinguished_names

  dynamic "service_account_credentials" {
    for_each = var.service_account_credentials != null ? [var.service_account_credentials] : []
    content {
      account_name     = service_account_credentials.value.account_name
      account_password = service_account_credentials.value.account_password
    }
  }
}