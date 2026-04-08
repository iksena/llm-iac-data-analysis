output "arn" {
  description = "ARN of the provisioned product."
  value       = aws_servicecatalog_provisioned_product.this.arn
}

output "cloudwatch_dashboard_names" {
  description = "Set of CloudWatch dashboards that were created when provisioning the product."
  value       = aws_servicecatalog_provisioned_product.this.cloudwatch_dashboard_names
}

output "created_time" {
  description = "Time when the provisioned product was created."
  value       = aws_servicecatalog_provisioned_product.this.created_time
}

output "id" {
  description = "Provisioned Product ID."
  value       = aws_servicecatalog_provisioned_product.this.id
}

output "last_provisioning_record_id" {
  description = "Record identifier of the last request performed on this provisioned product of the following types: ProvisionedProduct, UpdateProvisionedProduct, ExecuteProvisionedProductPlan, TerminateProvisionedProduct."
  value       = aws_servicecatalog_provisioned_product.this.last_provisioning_record_id
}

output "last_record_id" {
  description = "Record identifier of the last request performed on this provisioned product."
  value       = aws_servicecatalog_provisioned_product.this.last_record_id
}

output "last_successful_provisioning_record_id" {
  description = "Record identifier of the last successful request performed on this provisioned product of the following types: ProvisionedProduct, UpdateProvisionedProduct, ExecuteProvisionedProductPlan, TerminateProvisionedProduct."
  value       = aws_servicecatalog_provisioned_product.this.last_successful_provisioning_record_id
}

output "launch_role_arn" {
  description = "ARN of the launch role associated with the provisioned product."
  value       = aws_servicecatalog_provisioned_product.this.launch_role_arn
}

output "outputs" {
  description = "The set of outputs for the product created."
  value       = aws_servicecatalog_provisioned_product.this.outputs
}

output "status" {
  description = "Current status of the provisioned product."
  value       = aws_servicecatalog_provisioned_product.this.status
}

output "status_message" {
  description = "Current status message of the provisioned product."
  value       = aws_servicecatalog_provisioned_product.this.status_message
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_servicecatalog_provisioned_product.this.tags_all
}

output "type" {
  description = "Type of provisioned product. Valid values are CFN_STACK and CFN_STACKSET."
  value       = aws_servicecatalog_provisioned_product.this.type
}