resource "aws_elasticache_user_group_association" "this" {
  region        = var.region
  user_group_id = var.user_group_id
  user_id       = var.user_id

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}