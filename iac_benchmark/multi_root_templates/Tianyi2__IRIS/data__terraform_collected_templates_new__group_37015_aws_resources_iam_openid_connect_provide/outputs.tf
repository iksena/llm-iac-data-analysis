output "arn" {
  description = "ARN assigned by AWS for this provider"
  value       = aws_iam_openid_connect_provider.this.arn
}

output "url" {
  description = "URL of the identity provider"
  value       = aws_iam_openid_connect_provider.this.url
}

output "client_id_list" {
  description = "List of client IDs for the OpenID Connect provider"
  value       = aws_iam_openid_connect_provider.this.client_id_list
}

output "thumbprint_list" {
  description = "List of server certificate thumbprints for the OpenID Connect provider"
  value       = aws_iam_openid_connect_provider.this.thumbprint_list
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_iam_openid_connect_provider.this.tags_all
}