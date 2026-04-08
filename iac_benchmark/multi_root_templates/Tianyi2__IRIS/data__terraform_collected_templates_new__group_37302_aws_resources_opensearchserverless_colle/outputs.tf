output "arn" {
  description = "Amazon Resource Name (ARN) of the collection"
  value       = aws_opensearchserverless_collection.this.arn
}

output "collection_endpoint" {
  description = "Collection-specific endpoint used to submit index, search, and data upload requests to an OpenSearch Serverless collection"
  value       = aws_opensearchserverless_collection.this.collection_endpoint
}

output "dashboard_endpoint" {
  description = "Collection-specific endpoint used to access OpenSearch Dashboards"
  value       = aws_opensearchserverless_collection.this.dashboard_endpoint
}

output "kms_key_arn" {
  description = "The ARN of the Amazon Web Services KMS key used to encrypt the collection"
  value       = aws_opensearchserverless_collection.this.kms_key_arn
}

output "id" {
  description = "Unique identifier for the collection"
  value       = aws_opensearchserverless_collection.this.id
}

output "name" {
  description = "Name of the collection"
  value       = aws_opensearchserverless_collection.this.name
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_opensearchserverless_collection.this.region
}

output "description" {
  description = "Description of the collection"
  value       = aws_opensearchserverless_collection.this.description
}

output "standby_replicas" {
  description = "Indicates whether standby replicas are used for the collection"
  value       = aws_opensearchserverless_collection.this.standby_replicas
}

output "tags" {
  description = "Map of tags assigned to the collection"
  value       = aws_opensearchserverless_collection.this.tags
}

output "type" {
  description = "Type of collection"
  value       = aws_opensearchserverless_collection.this.type
}