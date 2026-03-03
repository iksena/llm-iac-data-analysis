To fulfill the business need, we will create an AWS ElastiCache Redis user with a password. This involves setting up an ElastiCache user resource, which requires an IAM role for access, and configuring the necessary parameters such as the user ID, user name, and password. We will use the AWS provider to manage the resources in a specified region. The password will be securely stored using Terraform's sensitive variable feature.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_elasticache_user" "example" {
  user_id   = "my-redis-user"
  user_name = "myRedisUser"
  engine    = "redis"
  passwords = [var.redis_user_password]
  access_string = "on ~* +@all"

  tags = {
    Name = "MyRedisUser"
  }
}

variable "redis_user_password" {
  description = "The password for the ElastiCache Redis user"
  type        = string
  sensitive   = true
  default     = "defaultPassword123!" # Replace with a secure password
}
```
</iac_template>

This Terraform configuration sets up an ElastiCache Redis user with a specified user ID and name. The password is managed as a sensitive variable to ensure security. The access string grants full access to all commands and keys. The configuration is set to deploy in the `us-west-2` region.