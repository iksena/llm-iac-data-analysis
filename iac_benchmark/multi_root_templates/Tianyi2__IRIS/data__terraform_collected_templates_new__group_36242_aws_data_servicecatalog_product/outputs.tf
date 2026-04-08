output "arn" {
  description = "ARN of the product"
  value       = data.aws_servicecatalog_product.this.arn
}

output "created_time" {
  description = "Time when the product was created"
  value       = data.aws_servicecatalog_product.this.created_time
}

output "description" {
  description = "Description of the product"
  value       = data.aws_servicecatalog_product.this.description
}

output "distributor" {
  description = "Vendor of the product"
  value       = data.aws_servicecatalog_product.this.distributor
}

output "has_default_path" {
  description = "Whether the product has a default path"
  value       = data.aws_servicecatalog_product.this.has_default_path
}

output "id" {
  description = "ID of the product"
  value       = data.aws_servicecatalog_product.this.id
}

output "name" {
  description = "Name of the product"
  value       = data.aws_servicecatalog_product.this.name
}

output "owner" {
  description = "Owner of the product"
  value       = data.aws_servicecatalog_product.this.owner
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_servicecatalog_product.this.region
}

output "status" {
  description = "Status of the product"
  value       = data.aws_servicecatalog_product.this.status
}

output "support_description" {
  description = "Field that provides support information about the product"
  value       = data.aws_servicecatalog_product.this.support_description
}

output "support_email" {
  description = "Contact email for product support"
  value       = data.aws_servicecatalog_product.this.support_email
}

output "support_url" {
  description = "Contact URL for product support"
  value       = data.aws_servicecatalog_product.this.support_url
}

output "tags" {
  description = "Tags applied to the product"
  value       = data.aws_servicecatalog_product.this.tags
}

output "type" {
  description = "Type of product"
  value       = data.aws_servicecatalog_product.this.type
}

output "accept_language" {
  description = "Language code used for the request"
  value       = data.aws_servicecatalog_product.this.accept_language
}