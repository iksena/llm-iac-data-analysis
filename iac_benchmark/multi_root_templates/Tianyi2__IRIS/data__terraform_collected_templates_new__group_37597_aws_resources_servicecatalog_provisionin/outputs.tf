output "created_time" {
  description = "Time when the provisioning artifact was created"
  value       = aws_servicecatalog_provisioning_artifact.this.created_time
}

output "id" {
  description = "Provisioning artifact identifier and product identifier separated by a colon"
  value       = aws_servicecatalog_provisioning_artifact.this.id
}

output "provisioning_artifact_id" {
  description = "Provisioning artifact identifier"
  value       = aws_servicecatalog_provisioning_artifact.this.provisioning_artifact_id
}


output "product_id" {
  description = "Identifier of the product"
  value       = aws_servicecatalog_provisioning_artifact.this.product_id
}

output "template_physical_id" {
  description = "Template source as the physical ID of the resource that contains the template"
  value       = aws_servicecatalog_provisioning_artifact.this.template_physical_id
}

output "template_url" {
  description = "Template source as URL of the CloudFormation template in Amazon S3"
  value       = aws_servicecatalog_provisioning_artifact.this.template_url
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_servicecatalog_provisioning_artifact.this.region
}

output "accept_language" {
  description = "Language code"
  value       = aws_servicecatalog_provisioning_artifact.this.accept_language
}

output "active" {
  description = "Whether the product version is active"
  value       = aws_servicecatalog_provisioning_artifact.this.active
}

output "description" {
  description = "Description of the provisioning artifact"
  value       = aws_servicecatalog_provisioning_artifact.this.description
}

output "disable_template_validation" {
  description = "Whether AWS Service Catalog stops validating the specified provisioning artifact template"
  value       = aws_servicecatalog_provisioning_artifact.this.disable_template_validation
}

output "guidance" {
  description = "Information set by the administrator to provide guidance to end users"
  value       = aws_servicecatalog_provisioning_artifact.this.guidance
}

output "name" {
  description = "Name of the provisioning artifact"
  value       = aws_servicecatalog_provisioning_artifact.this.name
}

output "type" {
  description = "Type of provisioning artifact"
  value       = aws_servicecatalog_provisioning_artifact.this.type
}