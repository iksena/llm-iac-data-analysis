output "arn" {
  description = "Amazon Resource Name (ARN) of the collection."
  value       = data.aws_opensearchserverless_collection.this.arn
}

output "collection_endpoint" {
  description = "Collection-specific endpoint used to submit index, search, and data upload requests to an OpenSearch Serverless collection."
  value       = data.aws_opensearchserverless_collection.this.collection_endpoint
}

output "created_date" {
  description = "Date the Collection was created."
  value       = data.aws_opensearchserverless_collection.this.created_date
}

output "dashboard_endpoint" {
  description = "Collection-specific endpoint used to access OpenSearch Dashboards."
  value       = data.aws_opensearchserverless_collection.this.dashboard_endpoint
}

output "description" {
  description = "Description of the collection."
  value       = data.aws_opensearchserverless_collection.this.description
}

output "failure_code" {
  description = "A failure code associated with the collection."
  value       = data.aws_opensearchserverless_collection.this.failure_code
}

output "id" {
  description = "ID of the collection."
  value       = data.aws_opensearchserverless_collection.this.id
}

output "kms_key_arn" {
  description = "The ARN of the Amazon Web Services KMS key used to encrypt the collection."
  value       = data.aws_opensearchserverless_collection.this.kms_key_arn
}

output "last_modified_date" {
  description = "Date the Collection was last modified."
  value       = data.aws_opensearchserverless_collection.this.last_modified_date
}

output "name" {
  description = "Name of the collection."
  value       = data.aws_opensearchserverless_collection.this.name
}

output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_opensearchserverless_collection.this.region
}

output "standby_replicas" {
  description = "Indicates whether standby replicas should be used for a collection."
  value       = data.aws_opensearchserverless_collection.this.standby_replicas
}

output "tags" {
  description = "A map of tags to assign to the collection."
  value       = data.aws_opensearchserverless_collection.this.tags
}

output "type" {
  description = "Type of collection."
  value       = data.aws_opensearchserverless_collection.this.type
}