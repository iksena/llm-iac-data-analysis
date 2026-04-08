output "resource_tag_mapping_list" {
  description = "List of objects matching the search criteria."
  value       = data.aws_resourcegroupstaggingapi_resources.this.resource_tag_mapping_list
}

output "compliance_details" {
  description = "List of objects with information that shows whether a resource is compliant with the effective tag policy, including details on any noncompliant tag keys."
  value       = [for mapping in data.aws_resourcegroupstaggingapi_resources.this.resource_tag_mapping_list : mapping.compliance_details]
}

output "compliance_status" {
  description = "Whether the resource is compliant."
  value       = flatten([for mapping in data.aws_resourcegroupstaggingapi_resources.this.resource_tag_mapping_list : [for compliance in mapping.compliance_details : compliance.compliance_status]])
}

output "keys_with_noncompliant_values" {
  description = "Set of tag keys with non-compliant tag values."
  value       = flatten([for mapping in data.aws_resourcegroupstaggingapi_resources.this.resource_tag_mapping_list : [for compliance in mapping.compliance_details : compliance.keys_with_noncompliant_values]])
}

output "non_compliant_keys" {
  description = "Set of non-compliant tag keys."
  value       = flatten([for mapping in data.aws_resourcegroupstaggingapi_resources.this.resource_tag_mapping_list : [for compliance in mapping.compliance_details : compliance.non_compliant_keys]])
}

output "resource_arn" {
  description = "ARN of the resource."
  value       = [for mapping in data.aws_resourcegroupstaggingapi_resources.this.resource_tag_mapping_list : mapping.resource_arn]
}

output "tags" {
  description = "Map of tags assigned to the resource."
  value       = [for mapping in data.aws_resourcegroupstaggingapi_resources.this.resource_tag_mapping_list : mapping.tags]
}