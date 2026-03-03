I'll help you create a Terraform configuration to provision an AWS ElastiCache user resource with a password. This configuration will:

1. Set up the AWS provider
2. Create an ElastiCache user with a specified username and password
3. Use password management best practices by storing it in a variable

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Variable for the password
variable "elasticache_user_password" {
  description = "Password for ElastiCache user"
  type        = string
  default     = "MyP@ssw0rd123!" # Change this in production
  sensitive   = true
}

# Variable for the username
variable "elasticache_username" {
  description = "Username for ElastiCache user"
  type        = string
  default     = "cache-admin"
}

# Create ElastiCache User
resource "aws_elasticache_user" "cache_user" {
  user_id       = var.elasticache_username
  user_name     = var.elasticache_username
  access_string = "on ~* +@all"  # Grants all permissions
  engine        = "REDIS"
  passwords     = [var.elasticache_user_password]

  authentication_mode {
    type      = "password"
    passwords = [var.elasticache_user_password]
  }
}

# Output the user ID
output "elasticache_user_id" {
  value = aws_elasticache_user.cache_user.user_id
}
</iac_template>

This Terraform configuration:
1. Sets up the AWS provider in the us-west-2 region
2. Defines variables for the username and password (with default values)
3. Creates an ElastiCache user with:
   - A specified username and password
   - Full access permissions (can be restricted as needed)
   - Redis as the engine type
   - Password authentication mode
4. Includes an output to display the created user ID

Note: In a production environment, you should:
- Change the default password to something more secure
- Consider using AWS Secrets Manager or Parameter Store for password management
- Adjust the access_string permissions according to your security requirements
- The password must be at least 16 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character