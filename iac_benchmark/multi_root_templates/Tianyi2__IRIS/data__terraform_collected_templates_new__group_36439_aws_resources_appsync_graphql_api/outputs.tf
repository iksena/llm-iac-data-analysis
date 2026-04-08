output "id" {
  description = "API ID"
  value       = aws_appsync_graphql_api.this.id
}

output "arn" {
  description = "ARN"
  value       = aws_appsync_graphql_api.this.arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_appsync_graphql_api.this.tags_all
}

output "uris" {
  description = "Map of URIs associated with the API E.g., uris[\"GRAPHQL\"] = https://ID.appsync-api.REGION.amazonaws.com/graphql"
  value       = aws_appsync_graphql_api.this.uris
}