resource "aws_finspace_kx_user" "this" {
  name           = var.name
  environment_id = var.environment_id
  iam_role       = var.iam_role
  region         = var.region
  tags           = var.tags

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}