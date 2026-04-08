resource "aws_elasticache_user_group" "this" {
  engine        = var.engine
  user_group_id = var.user_group_id
  region        = var.region
  user_ids      = var.user_ids
  tags          = var.tags
}