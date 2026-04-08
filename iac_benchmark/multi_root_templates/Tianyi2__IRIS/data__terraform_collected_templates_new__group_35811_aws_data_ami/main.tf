data "aws_ami" "this" {
  region              = var.region
  owners              = var.owners
  most_recent         = var.most_recent
  executable_users    = var.executable_users
  include_deprecated  = var.include_deprecated
  allow_unsafe_filter = var.allow_unsafe_filter
  name_regex          = var.name_regex

  dynamic "filter" {
    for_each = var.filter != null ? var.filter : []
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}