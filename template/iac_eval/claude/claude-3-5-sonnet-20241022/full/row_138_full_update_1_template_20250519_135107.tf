I'll help you create a Terraform configuration to associate an existing ElastiCache user with an existing user group. This configuration will use the AWS provider and create an association between the specified user and user group using the `aws_elasticache_user_group_association` resource.

The configuration will:
1. Set up the AWS provider
2. Define variables for the user ID and user group ID
3. Create the association between the user and user group

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

This Terraform configuration creates an association between an existing ElastiCache user and an existing user group. You'll need to:

1. Replace the default values in the variables with your actual ElastiCache user ID and user group ID
2. Make sure the AWS provider is configured with appropriate credentials
3. Ensure the specified user and user group exist in your AWS account

The configuration includes:
- AWS provider configuration for the us-west-2 region
- Variables for the user ID and user group ID with default values
- The user group association resource
- An output to display the association ID

To use this configuration, you'll need to have:
- AWS credentials configured
- An existing ElastiCache user
- An existing ElastiCache user group

You can customize the region and variable default values according to your specific requirements.