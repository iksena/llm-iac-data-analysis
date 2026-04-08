output "arn" {
  description = "ARN of Transfer Server."
  value       = data.aws_transfer_server.this.arn
}

output "certificate" {
  description = "ARN of any certificate."
  value       = data.aws_transfer_server.this.certificate
}

output "domain" {
  description = "The domain of the storage system that is used for file transfers."
  value       = data.aws_transfer_server.this.domain
}

output "endpoint" {
  description = "Endpoint of the Transfer Server."
  value       = data.aws_transfer_server.this.endpoint
}

output "endpoint_type" {
  description = "Type of endpoint that the server is connected to."
  value       = data.aws_transfer_server.this.endpoint_type
}

output "identity_provider_type" {
  description = "The mode of authentication enabled for this service."
  value       = data.aws_transfer_server.this.identity_provider_type
}

output "invocation_role" {
  description = "ARN of the IAM role used to authenticate the user account with an identity_provider_type of API_GATEWAY."
  value       = data.aws_transfer_server.this.invocation_role
}

output "logging_role" {
  description = "ARN of an IAM role that allows the service to write your SFTP users' activity to your Amazon CloudWatch logs."
  value       = data.aws_transfer_server.this.logging_role
}

output "protocols" {
  description = "File transfer protocol or protocols over which your file transfer protocol client can connect to your server's endpoint."
  value       = data.aws_transfer_server.this.protocols
}

output "security_policy_name" {
  description = "The name of the security policy that is attached to the server."
  value       = data.aws_transfer_server.this.security_policy_name
}

output "structured_log_destinations" {
  description = "A set of ARNs of destinations that will receive structured logs from the transfer server."
  value       = data.aws_transfer_server.this.structured_log_destinations
}

output "tags" {
  description = "Map of tags assigned to the resource."
  value       = data.aws_transfer_server.this.tags
}

output "url" {
  description = "URL of the service endpoint used to authenticate users with an identity_provider_type of API_GATEWAY."
  value       = data.aws_transfer_server.this.url
}