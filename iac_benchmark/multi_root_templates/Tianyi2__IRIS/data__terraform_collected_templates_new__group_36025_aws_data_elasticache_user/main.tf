data "aws_elasticache_user" "this" {
  region  = var.region
  user_id = var.user_id
}