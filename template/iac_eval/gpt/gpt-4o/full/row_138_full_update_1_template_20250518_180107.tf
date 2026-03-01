To associate an existing ElastiCache user with an existing user group, we will create a Terraform configuration that uses the AWS provider. This configuration will include the necessary resources to link the specified ElastiCache user to the user group. We will assume that the ElastiCache user and user group already exist, and we will use their identifiers to establish the association.

The Terraform configuration will include:
- AWS provider configuration.
- Data sources to fetch the existing ElastiCache user and user group.
- A resource to create the association between the ElastiCache user and the user group.

Here is the Terraform HCL program:

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

# Data source to fetch the existing ElastiCache user
data "aws_elasticache_user" "existing_user" {
  user_id = "my-existing-user-id" # Replace with your actual ElastiCache user ID
}

# Data source to fetch the existing ElastiCache user group
data "aws_elasticache_user_group" "existing_user_group" {
  user_group_id = "my-existing-user-group-id" # Replace with your actual ElastiCache user group ID
}

# Resource to associate the ElastiCache user with the user group
resource "aws_elasticache_user_group_association" "user_group_association" {
  user_group_id = data.aws_elasticache_user_group.existing_user_group.user_group_id
  user_id       = data.aws_elasticache_user.existing_user.user_id
}
```
</iac_template>

This configuration will successfully associate the specified ElastiCache user with the specified user group in the AWS region `us-west-2`. Make sure to replace the placeholders with the actual IDs of your ElastiCache user and user group.