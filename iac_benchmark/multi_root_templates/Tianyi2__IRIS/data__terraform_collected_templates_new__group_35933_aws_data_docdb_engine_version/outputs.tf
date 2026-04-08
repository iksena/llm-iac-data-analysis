output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_docdb_engine_version.this.region
}

output "engine" {
  description = "DB engine."
  value       = data.aws_docdb_engine_version.this.engine
}

output "parameter_group_family" {
  description = "Name of a specific DB parameter group family."
  value       = data.aws_docdb_engine_version.this.parameter_group_family
}

output "preferred_versions" {
  description = "Ordered list of preferred engine versions."
  value       = data.aws_docdb_engine_version.this.preferred_versions
}

output "version" {
  description = "Version of the DB engine."
  value       = data.aws_docdb_engine_version.this.version
}

output "engine_description" {
  description = "Description of the database engine."
  value       = data.aws_docdb_engine_version.this.engine_description
}

output "exportable_log_types" {
  description = "Set of log types that the database engine has available for export to CloudWatch Logs."
  value       = data.aws_docdb_engine_version.this.exportable_log_types
}

output "supports_log_exports_to_cloudwatch" {
  description = "Indicates whether the engine version supports exporting the log types specified by exportable_log_types to CloudWatch Logs."
  value       = data.aws_docdb_engine_version.this.supports_log_exports_to_cloudwatch
}

output "valid_upgrade_targets" {
  description = "A set of engine versions that this database engine version can be upgraded to."
  value       = data.aws_docdb_engine_version.this.valid_upgrade_targets
}

output "version_description" {
  description = "Description of the database engine version."
  value       = data.aws_docdb_engine_version.this.version_description
}