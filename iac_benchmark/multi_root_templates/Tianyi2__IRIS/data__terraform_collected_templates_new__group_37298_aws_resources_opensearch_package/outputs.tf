output "id" {
  description = "The Id of the package."
  value       = aws_opensearch_package.this.id
}

output "available_package_version" {
  description = "The current version of the package."
  value       = aws_opensearch_package.this.available_package_version
}

output "engine_version" {
  description = "Engine version that the package is compatible with."
  value       = aws_opensearch_package.this.engine_version
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_opensearch_package.this.region
}

output "package_name" {
  description = "Unique name for the package."
  value       = aws_opensearch_package.this.package_name
}

output "package_type" {
  description = "The type of package."
  value       = aws_opensearch_package.this.package_type
}

output "package_source" {
  description = "Configuration block for the package source options."
  value       = aws_opensearch_package.this.package_source
}

output "package_description" {
  description = "Description of the package."
  value       = aws_opensearch_package.this.package_description
}