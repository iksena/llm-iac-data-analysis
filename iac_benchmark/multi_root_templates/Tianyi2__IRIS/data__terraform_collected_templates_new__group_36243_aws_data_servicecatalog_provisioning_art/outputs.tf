output "product_id" {
  description = "Product identifier"
  value       = data.aws_servicecatalog_provisioning_artifacts.this.product_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_servicecatalog_provisioning_artifacts.this.region
}

output "accept_language" {
  description = "Language code"
  value       = data.aws_servicecatalog_provisioning_artifacts.this.accept_language
}

output "provisioning_artifact_details" {
  description = "List with information about the provisioning artifacts"
  value       = data.aws_servicecatalog_provisioning_artifacts.this.provisioning_artifact_details
}

output "provisioning_artifact_details_active" {
  description = "List of active status for each provisioning artifact"
  value       = [for artifact in data.aws_servicecatalog_provisioning_artifacts.this.provisioning_artifact_details : artifact.active]
}

output "provisioning_artifact_details_created_time" {
  description = "List of creation times for each provisioning artifact"
  value       = [for artifact in data.aws_servicecatalog_provisioning_artifacts.this.provisioning_artifact_details : artifact.created_time]
}

output "provisioning_artifact_details_description" {
  description = "List of descriptions for each provisioning artifact"
  value       = [for artifact in data.aws_servicecatalog_provisioning_artifacts.this.provisioning_artifact_details : artifact.description]
}

output "provisioning_artifact_details_guidance" {
  description = "List of guidance information for each provisioning artifact"
  value       = [for artifact in data.aws_servicecatalog_provisioning_artifacts.this.provisioning_artifact_details : artifact.guidance]
}

output "provisioning_artifact_details_id" {
  description = "List of identifiers for each provisioning artifact"
  value       = [for artifact in data.aws_servicecatalog_provisioning_artifacts.this.provisioning_artifact_details : artifact.id]
}

output "provisioning_artifact_details_name" {
  description = "List of names for each provisioning artifact"
  value       = [for artifact in data.aws_servicecatalog_provisioning_artifacts.this.provisioning_artifact_details : artifact.name]
}

output "provisioning_artifact_details_type" {
  description = "List of types for each provisioning artifact"
  value       = [for artifact in data.aws_servicecatalog_provisioning_artifacts.this.provisioning_artifact_details : artifact.type]
}