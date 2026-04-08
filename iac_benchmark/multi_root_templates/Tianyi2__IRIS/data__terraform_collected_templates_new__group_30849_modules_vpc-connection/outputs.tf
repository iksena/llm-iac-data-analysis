output "region" {
  description = "The AWS region this module resources resides in."
  value       = aws_quicksight_vpc_connection.this.region
}

output "id" {
  description = "The ID of the QuickSight VPC connection."
  value       = aws_quicksight_vpc_connection.this.vpc_connection_id
}

output "arn" {
  description = "The ARN of the QuickSight VPC connection."
  value       = aws_quicksight_vpc_connection.this.arn
}

output "name" {
  description = "The identifier of the QuickSight VPC connection."
  value       = aws_quicksight_vpc_connection.this.vpc_connection_id
}

output "display_name" {
  description = "The display name of the QuickSight VPC connection."
  value       = aws_quicksight_vpc_connection.this.name
}

output "status" {
  description = "The availability status of the QuickSight VPC connection. Valid values are `AVAILABLE`, `UNAVAILABLE` or `PARTIALLY_AVAILABLE`."
  value       = aws_quicksight_vpc_connection.this.availability_status
}

output "default_execution_role" {
  description = "The configuration of the default execution role for the QuickSight VPC connection."
  value = one([
    for role in module.execution_role : {
      id   = role.id
      arn  = role.arn
      name = role.name
    }
  ])
}

output "execution_role" {
  description = "The ID of execution role for the QuickSight VPC connection."
  value       = aws_quicksight_vpc_connection.this.role_arn
}

output "vpc" {
  description = "The VPC ID for the QuickSight VPC connection."
  value       = local.vpc_id
}

output "subnets" {
  description = "A list of subnet IDs for the QuickSight VPC connection."
  value       = aws_quicksight_vpc_connection.this.subnet_ids
}

output "default_security_group" {
  description = "The configuration of the default security group for the QuickSight VPC connection."
  value = one([
    for security_group in module.security_group : {
      id   = security_group.id
      name = security_group.name
    }
  ])
}

output "security_groups" {
  description = "A list of security group IDs for the QuickSight VPC connection."
  value       = aws_quicksight_vpc_connection.this.security_group_ids
}

output "dns_resolvers" {
  description = "A list of IP addresses of DNS resolver endpoints for the QuickSight VPC connection."
  value       = aws_quicksight_vpc_connection.this.dns_resolvers
}

# output "debug" {
#   value = {
#     for k, v in aws_quicksight_vpc_connection.this :
#     k => v
#     if !contains(["aws_account_id", "arn", "id", "name", "vpc_connection_id", "tags", "tags_all", "availability_status", "subnet_ids", "dns_resolvers", "security_group_ids", "timeouts", "role_arn"], k)
#   }
# }

output "resource_group" {
  description = "The resource group created to manage resources in this module."
  value = merge(
    {
      enabled = var.resource_group.enabled && var.module_tags_enabled
    },
    (var.resource_group.enabled && var.module_tags_enabled
      ? {
        arn  = module.resource_group[0].arn
        name = module.resource_group[0].name
      }
      : {}
    )
  )
}
