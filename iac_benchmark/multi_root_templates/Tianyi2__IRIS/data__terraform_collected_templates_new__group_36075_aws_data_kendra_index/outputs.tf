output "arn" {
  description = "ARN of the Index"
  value       = data.aws_kendra_index.this.arn
}

output "capacity_units" {
  description = "Block that sets the number of additional document storage and query capacity units that should be used by the index"
  value       = data.aws_kendra_index.this.capacity_units
}

output "created_at" {
  description = "Unix datetime that the index was created"
  value       = data.aws_kendra_index.this.created_at
}

output "description" {
  description = "Description of the Index"
  value       = data.aws_kendra_index.this.description
}

output "document_metadata_configuration_updates" {
  description = "One or more blocks that specify the configuration settings for any metadata applied to the documents in the index"
  value       = data.aws_kendra_index.this.document_metadata_configuration_updates
}

output "edition" {
  description = "Amazon Kendra edition for the index"
  value       = data.aws_kendra_index.this.edition
}

output "error_message" {
  description = "When the Status field value is FAILED, this contains a message that explains why"
  value       = data.aws_kendra_index.this.error_message
}

output "id" {
  description = "Identifier of the Index"
  value       = data.aws_kendra_index.this.id
}

output "index_statistics" {
  description = "Block that provides information about the number of FAQ questions and answers and the number of text documents indexed"
  value       = data.aws_kendra_index.this.index_statistics
}

output "name" {
  description = "Name of the Index"
  value       = data.aws_kendra_index.this.name
}

output "role_arn" {
  description = "An AWS Identity and Access Management (IAM) role that gives Amazon Kendra permissions to access your Amazon CloudWatch logs and metrics"
  value       = data.aws_kendra_index.this.role_arn
}

output "server_side_encryption_configuration" {
  description = "A block that specifies the identifier of the AWS KMS customer managed key (CMK) that's used to encrypt data indexed by Amazon Kendra"
  value       = data.aws_kendra_index.this.server_side_encryption_configuration
}

output "status" {
  description = "Current status of the index. When the value is ACTIVE, the index is ready for use"
  value       = data.aws_kendra_index.this.status
}

output "updated_at" {
  description = "Unix datetime that the index was last updated"
  value       = data.aws_kendra_index.this.updated_at
}

output "user_context_policy" {
  description = "User context policy. Valid values are ATTRIBUTE_FILTER or USER_TOKEN"
  value       = data.aws_kendra_index.this.user_context_policy
}

output "user_group_resolution_configuration" {
  description = "A block that enables fetching access levels of groups and users from an AWS Single Sign-On identity source"
  value       = data.aws_kendra_index.this.user_group_resolution_configuration
}

output "user_token_configurations" {
  description = "A block that specifies the user token configuration"
  value       = data.aws_kendra_index.this.user_token_configurations
}

output "tags" {
  description = "Metadata that helps organize the Indices you create"
  value       = data.aws_kendra_index.this.tags
}