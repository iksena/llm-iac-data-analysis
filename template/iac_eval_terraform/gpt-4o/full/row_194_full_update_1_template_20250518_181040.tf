To authenticate an ElastiCache user with Redis, we need to set up an Amazon ElastiCache for Redis cluster and create a user with specific access permissions. We'll use AWS IAM roles to manage permissions and ensure secure access to the ElastiCache resources. The Terraform configuration will include the setup of the AWS provider, the creation of a Redis cluster, and the configuration of an ElastiCache user with authentication details.

Here's the Terraform configuration to achieve this:

<iac_template>
```hcl
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
```
</iac_template>

### Explanation:
- **Provider Configuration**: We configure the AWS provider to use the `us-west-2` region.
- **ElastiCache User**: We create an ElastiCache user with a specified user ID, name, and password. The `access_string` grants full access to all commands.
- **ElastiCache User Group**: We create a user group and associate the previously created user with it.
- **ElastiCache Replication Group**: We set up a Redis replication group with two nodes, enabling automatic failover for high availability. The user group is associated with the replication group to manage access.