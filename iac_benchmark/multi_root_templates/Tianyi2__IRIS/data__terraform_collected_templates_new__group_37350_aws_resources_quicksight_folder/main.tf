resource "aws_quicksight_folder" "this" {
  folder_id         = var.folder_id
  name              = var.name
  aws_account_id    = var.aws_account_id
  folder_type       = var.folder_type
  parent_folder_arn = var.parent_folder_arn
  region            = var.region
  tags              = var.tags

  dynamic "permissions" {
    for_each = var.permissions
    content {
      actions   = permissions.value.actions
      principal = permissions.value.principal
    }
  }

  timeouts {
    create = "5m"
    read   = "5m"
    update = "5m"
    delete = "5m"
  }
}