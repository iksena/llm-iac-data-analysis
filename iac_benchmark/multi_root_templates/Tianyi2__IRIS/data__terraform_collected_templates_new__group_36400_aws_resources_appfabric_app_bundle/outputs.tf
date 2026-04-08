output "arn" {
  description = "ARN of the AppBundle."
  value       = aws_appfabric_app_bundle.this.arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_appfabric_app_bundle.this.tags_all
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_appfabric_app_bundle.this.region
}

output "customer_managed_key_arn" {
  description = "The Amazon Resource Name (ARN) of the AWS Key Management Service (AWS KMS) key used to encrypt the application data."
  value       = aws_appfabric_app_bundle.this.customer_managed_key_arn
}

output "tags" {
  description = "Map of tags assigned to the resource."
  value       = aws_appfabric_app_bundle.this.tags
}