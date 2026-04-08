data "aws_ami_ids" "this" {
  region             = var.region
  owners             = var.owners
  executable_users   = var.executable_users
  name_regex         = var.name_regex
  sort_ascending     = var.sort_ascending
  include_deprecated = var.include_deprecated

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  timeouts {
    read = var.timeouts.read
  }
}