output "arn" {
  description = "ARN of the OpenID Connect provider"
  value       = data.aws_iam_openid_connect_provider.this.arn
}

output "url" {
  description = "URL of the OpenID Connect provider"
  value       = data.aws_iam_openid_connect_provider.this.url
}

output "client_id_list" {
  description = "List of client IDs (also known as audiences). When a mobile or web app registers with an OpenID Connect provider, they establish a value that identifies the application. (This is the value that's sent as the client_id parameter on OAuth requests.)"
  value       = data.aws_iam_openid_connect_provider.this.client_id_list
}

output "thumbprint_list" {
  description = "List of server certificate thumbprints for the OpenID Connect (OIDC) identity provider's server certificate(s)"
  value       = data.aws_iam_openid_connect_provider.this.thumbprint_list
}

output "tags" {
  description = "Map of resource tags for the IAM OIDC provider"
  value       = data.aws_iam_openid_connect_provider.this.tags
}