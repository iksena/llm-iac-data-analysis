provider "aws" {
  region = "us-west-2"
}

resource "aws_elasticache_user" "redis_user" {
  user_id   = "redis-user"
  user_name = "redisUser"
  engine    = "redis"
  passwords = ["YourSecurePassword123!"]
  access_string = "on ~* +@all"
}

resource "aws_elasticache_user_group" "redis_user_group" {
  user_group_id = "redis-user-group"
  engine        = "redis"
  user_ids      = [aws_elasticache_user.redis_user.user_id]
}

resource "aws_elasticache_replication_group" "redis_cluster" {
  replication_group_id          = "my-redis-cluster"
  replication_group_description = "Redis replication group for my application"
  node_type                     = "cache.t3.micro"
  number_cache_clusters         = 2
  engine                        = "redis"
  engine_version                = "6.x"
  parameter_group_name          = "default.redis6.x"
  automatic_failover_enabled    = true

  user_group_ids = [aws_elasticache_user_group.redis_user_group.user_group_id]

  tags = {
    Name = "MyRedisCluster"
  }
}