output "id" {
  description = "Query String."
  value       = data.aws_resourceexplorer2_search.this.id
}

output "resource_count" {
  description = "Number of resources that match the query."
  value       = data.aws_resourceexplorer2_search.this.resource_count
}

output "resource_count_complete" {
  description = "Indicates whether the TotalResources value represents an exhaustive count of search results. If True, it indicates that the search was exhaustive. Every resource that matches the query was counted. If False, then the search reached the limit of 1,000 matching results, and stopped counting."
  value       = data.aws_resourceexplorer2_search.this.resource_count[0].complete
}

output "resource_count_total_resources" {
  description = "Number of resources that match the search query. This value can't exceed 1,000. If there are more than 1,000 resources that match the query, then only 1,000 are counted and the Complete field is set to false. We recommend that you refine your query to return a smaller number of results."
  value       = data.aws_resourceexplorer2_search.this.resource_count[0].total_resources
}

output "resources" {
  description = "List of structures that describe the resources that match the query."
  value       = data.aws_resourceexplorer2_search.this.resources
}

output "resources_arn" {
  description = "Amazon resource name of resource."
  value       = [for resource in data.aws_resourceexplorer2_search.this.resources : resource.arn]
}

output "resources_last_reported_at" {
  description = "Date and time that Resource Explorer last queried this resource and updated the index with the latest information about the resource."
  value       = [for resource in data.aws_resourceexplorer2_search.this.resources : resource.last_reported_at]
}

output "resources_owning_account_id" {
  description = "Amazon Web Services account that owns the resource."
  value       = [for resource in data.aws_resourceexplorer2_search.this.resources : resource.owning_account_id]
}

output "resources_properties" {
  description = "Structure with additional type-specific details about the resource."
  value       = [for resource in data.aws_resourceexplorer2_search.this.resources : resource.properties]
}

output "resources_properties_data" {
  description = "Details about this property. The content of this field is a JSON object that varies based on the resource type."
  value       = [for resource in data.aws_resourceexplorer2_search.this.resources : [for property in resource.properties : property.data]]
}

output "resources_properties_last_reported_at" {
  description = "The date and time that the information about this resource property was last updated."
  value       = [for resource in data.aws_resourceexplorer2_search.this.resources : [for property in resource.properties : property.last_reported_at]]
}

output "resources_properties_name" {
  description = "Name of this property of the resource."
  value       = [for resource in data.aws_resourceexplorer2_search.this.resources : [for property in resource.properties : property.name]]
}

output "resources_region" {
  description = "Amazon Web Services Region in which the resource was created and exists."
  value       = [for resource in data.aws_resourceexplorer2_search.this.resources : resource.region]
}

output "resources_resource_type" {
  description = "Type of the resource."
  value       = [for resource in data.aws_resourceexplorer2_search.this.resources : resource.resource_type]
}

output "resources_service" {
  description = "Amazon Web Service that owns the resource and is responsible for creating and updating it."
  value       = [for resource in data.aws_resourceexplorer2_search.this.resources : resource.service]
}