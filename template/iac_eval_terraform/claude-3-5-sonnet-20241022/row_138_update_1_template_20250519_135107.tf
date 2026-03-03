provider "aws" {
  region = "us-west-2"
}

# Variables
variable "elasticache_user_id" {
  description = "The ID of the existing ElastiCache user"
  type        = string
  default     = "default-user"  # Replace with your actual user ID
}

variable "elasticache_user_group_id" {
  description = "The ID of the existing ElastiCache user group"
  type        = string
  default     = "default-group"  # Replace with your actual user group ID
}

# Create the association between the user and user group
resource "aws_elasticache_user_group_association" "example" {
  user_id         = var.elasticache_user_id
  user_group_id   = var.elasticache_user_group_id
}

# Output the association details
output "user_group_association_id" {
  description = "The ID of the user group association"
  value       = aws_elasticache_user_group_association.example.id
}