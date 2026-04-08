output "summaries" {
  description = "Block with information about the launch path"
  value       = data.aws_servicecatalog_launch_paths.this.summaries
}

output "product_id" {
  description = "Product identifier"
  value       = data.aws_servicecatalog_launch_paths.this.product_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_servicecatalog_launch_paths.this.region
}

output "accept_language" {
  description = "Language code used"
  value       = data.aws_servicecatalog_launch_paths.this.accept_language
}