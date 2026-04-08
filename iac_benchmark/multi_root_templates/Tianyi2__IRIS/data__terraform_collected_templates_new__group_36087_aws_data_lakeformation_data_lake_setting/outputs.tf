output "admins" {
  description = "List of ARNs of AWS Lake Formation principals (IAM users or roles)."
  value       = data.aws_lakeformation_data_lake_settings.this.admins
}

output "allow_external_data_filtering" {
  description = "Whether to allow Amazon EMR clusters to access data managed by Lake Formation."
  value       = data.aws_lakeformation_data_lake_settings.this.allow_external_data_filtering
}

output "allow_full_table_external_data_access" {
  description = "Whether to allow a third-party query engine to get data access credentials without session tags when a caller has full data access permissions."
  value       = data.aws_lakeformation_data_lake_settings.this.allow_full_table_external_data_access
}

output "authorized_session_tag_value_list" {
  description = "Lake Formation relies on a privileged process secured by Amazon EMR or the third party integrator to tag the user's role while assuming it."
  value       = data.aws_lakeformation_data_lake_settings.this.authorized_session_tag_value_list
}

output "create_database_default_permissions" {
  description = "Up to three configuration blocks of principal permissions for default create database permissions."
  value       = data.aws_lakeformation_data_lake_settings.this.create_database_default_permissions
}

output "create_table_default_permissions" {
  description = "Up to three configuration blocks of principal permissions for default create table permissions."
  value       = data.aws_lakeformation_data_lake_settings.this.create_table_default_permissions
}

output "external_data_filtering_allow_list" {
  description = "A list of the account IDs of Amazon Web Services accounts with Amazon EMR clusters that are to perform data filtering."
  value       = data.aws_lakeformation_data_lake_settings.this.external_data_filtering_allow_list
}

output "parameters" {
  description = "Key-value map of additional configuration. CROSS_ACCOUNT_VERSION will be set to values \"1\", \"2\", \"3\", or \"4\". SET_CONTEXT will also be returned with a value of TRUE. In a fresh account, prior to configuring, CROSS_ACCOUNT_VERSION is \"1\"."
  value       = data.aws_lakeformation_data_lake_settings.this.parameters
}

output "read_only_admins" {
  description = "List of ARNs of AWS Lake Formation principals (IAM users or roles) with only view access to the resources."
  value       = data.aws_lakeformation_data_lake_settings.this.read_only_admins
}

output "trusted_resource_owners" {
  description = "List of the resource-owning account IDs that the caller's account can use to share their user access details (user ARNs)."
  value       = data.aws_lakeformation_data_lake_settings.this.trusted_resource_owners
}

output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_lakeformation_data_lake_settings.this.region
}

output "catalog_id" {
  description = "Identifier for the Data Catalog."
  value       = data.aws_lakeformation_data_lake_settings.this.catalog_id
}