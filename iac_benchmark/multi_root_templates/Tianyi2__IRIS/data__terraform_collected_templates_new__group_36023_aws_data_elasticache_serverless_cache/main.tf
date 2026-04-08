data "aws_elasticache_serverless_cache" "this" {
  name   = var.name
  region = var.region
}