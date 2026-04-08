locals {
  validate_workspace_params = (
    # Either workspace_id is provided alone, or directory_id and user_name are provided together
    (var.workspace_id != null && var.directory_id == null && var.user_name == null) ||
    (var.workspace_id == null && var.directory_id != null && var.user_name != null) ||
    (var.workspace_id == null && var.directory_id == null && var.user_name == null)
  ) ? null : file("ERROR: You must either provide workspace_id alone, or directory_id with user_name together. You cannot mix these parameters.")
}

data "aws_workspaces_workspace" "this" {
  directory_id = var.directory_id
  user_name    = var.user_name
  workspace_id = var.workspace_id
  tags         = var.tags
}