data "aws_workspaces_directory" "this" {
  directory_id = var.directory_id
  region       = var.region
}