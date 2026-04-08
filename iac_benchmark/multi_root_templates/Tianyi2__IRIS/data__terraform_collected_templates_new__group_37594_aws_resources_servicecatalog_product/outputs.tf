output "arn" {
  description = "ARN of the product."
  value       = aws_servicecatalog_product.this.arn
}

output "created_time" {
  description = "Time when the product was created."
  value       = aws_servicecatalog_product.this.created_time
}

output "has_default_path" {
  description = "Whether the product has a default path. If the product does not have a default path, call ListLaunchPaths to disambiguate between paths. Otherwise, ListLaunchPaths is not required, and the output of ProductViewSummary can be used directly with DescribeProvisioningParameters."
  value       = aws_servicecatalog_product.this.has_default_path
}

output "id" {
  description = "Product ID. For example, prod-dnigbtea24ste."
  value       = aws_servicecatalog_product.this.id
}

output "status" {
  description = "Status of the product."
  value       = aws_servicecatalog_product.this.status
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_servicecatalog_product.this.tags_all
}