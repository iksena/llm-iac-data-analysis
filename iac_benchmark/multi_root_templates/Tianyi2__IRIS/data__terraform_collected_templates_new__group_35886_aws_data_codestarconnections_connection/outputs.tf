output "connection_status" {
  description = "CodeStar Connection status. Possible values are PENDING, AVAILABLE and ERROR."
  value       = data.aws_codestarconnections_connection.this.connection_status
}

output "id" {
  description = "CodeStar Connection ARN."
  value       = data.aws_codestarconnections_connection.this.id
}

output "host_arn" {
  description = "ARN of the host associated with the connection."
  value       = data.aws_codestarconnections_connection.this.host_arn
}

output "name" {
  description = "Name of the CodeStar Connection. The name is unique in the calling AWS account."
  value       = data.aws_codestarconnections_connection.this.name
}

output "provider_type" {
  description = "Name of the external provider where your third-party code repository is configured. Possible values are Bitbucket, GitHub and GitLab."
  value       = data.aws_codestarconnections_connection.this.provider_type
}

output "tags" {
  description = "Map of key-value resource tags to associate with the resource."
  value       = data.aws_codestarconnections_connection.this.tags
}

output "arn" {
  description = "CodeStar Connection ARN."
  value       = data.aws_codestarconnections_connection.this.arn
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_codestarconnections_connection.this.region
}