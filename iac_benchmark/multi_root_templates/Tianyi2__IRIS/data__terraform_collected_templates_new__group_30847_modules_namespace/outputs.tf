output "region" {
  description = "The AWS region this module resources resides in."
  value       = aws_quicksight_namespace.this.region
}

output "arn" {
  description = "The ARN of the QuickSight namespace."
  value       = aws_quicksight_namespace.this.arn
}

output "name" {
  description = "The name of the QuickSight namespace."
  value       = aws_quicksight_namespace.this.namespace
}

output "status" {
  description = "The creation status of the QuickSight namespace."
  value       = aws_quicksight_namespace.this.creation_status
}

output "identity_store" {
  description = "The type of user identity directory."
  value       = aws_quicksight_namespace.this.identity_store
}

output "capacity_region" {
  description = "The AWS Region that you want to use for the free SPICE capacity for the new namespace."
  value       = aws_quicksight_namespace.this.capacity_region
}

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

# output "debug" {
#   value = {
#     for k, v in aws_quicksight_namespace.this :
#     k => v
#     if !contains(["arn", "namespace", "identity_store", "capacity_region", "region", "tags", "tags_all", "id", "timeouts", "aws_account_id", "creation_status"], k)
#   }
# }
