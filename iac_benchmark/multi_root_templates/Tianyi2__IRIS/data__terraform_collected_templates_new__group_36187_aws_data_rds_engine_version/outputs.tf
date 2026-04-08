output "engine" {
  description = "Database engine"
  value       = data.aws_rds_engine_version.this.engine
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_rds_engine_version.this.region
}

output "default_only" {
  description = "Whether the engine version must be an AWS-defined default version"
  value       = data.aws_rds_engine_version.this.default_only
}

output "has_major_target" {
  description = "Whether the engine version must have one or more major upgrade targets"
  value       = data.aws_rds_engine_version.this.has_major_target
}

output "has_minor_target" {
  description = "Whether the engine version must have one or more minor upgrade targets"
  value       = data.aws_rds_engine_version.this.has_minor_target
}

output "include_all" {
  description = "Whether the engine version status can either be deprecated or available"
  value       = data.aws_rds_engine_version.this.include_all
}

output "latest" {
  description = "Whether the engine version is the most recent version matching the other criteria"
  value       = data.aws_rds_engine_version.this.latest
}

output "parameter_group_family" {
  description = "Name of a specific database parameter group family"
  value       = data.aws_rds_engine_version.this.parameter_group_family
}

output "preferred_major_targets" {
  description = "Ordered list of preferred major version upgrade targets"
  value       = data.aws_rds_engine_version.this.preferred_major_targets
}

output "preferred_upgrade_targets" {
  description = "Ordered list of preferred version upgrade targets"
  value       = data.aws_rds_engine_version.this.preferred_upgrade_targets
}

output "preferred_versions" {
  description = "Ordered list of preferred versions"
  value       = data.aws_rds_engine_version.this.preferred_versions
}

output "version" {
  description = "Engine version"
  value       = data.aws_rds_engine_version.this.version
}

output "default_character_set" {
  description = "Default character set for new instances of the engine version"
  value       = data.aws_rds_engine_version.this.default_character_set
}

output "engine_description" {
  description = "Description of the engine"
  value       = data.aws_rds_engine_version.this.engine_description
}

output "exportable_log_types" {
  description = "Set of log types that the engine version has available for export to CloudWatch Logs"
  value       = data.aws_rds_engine_version.this.exportable_log_types
}

output "status" {
  description = "Status of the engine version, either available or deprecated"
  value       = data.aws_rds_engine_version.this.status
}

output "supported_character_sets" {
  description = "Set of character sets supported by the engine version"
  value       = data.aws_rds_engine_version.this.supported_character_sets
}

output "supported_feature_names" {
  description = "Set of features supported by the engine version"
  value       = data.aws_rds_engine_version.this.supported_feature_names
}

output "supported_modes" {
  description = "Set of supported engine version modes"
  value       = data.aws_rds_engine_version.this.supported_modes
}

output "supported_timezones" {
  description = "Set of the time zones supported by the engine version"
  value       = data.aws_rds_engine_version.this.supported_timezones
}

output "supports_certificate_rotation_without_restart" {
  description = "Whether the certificates can be rotated without restarting the Aurora instance"
  value       = data.aws_rds_engine_version.this.supports_certificate_rotation_without_restart
}

output "supports_global_databases" {
  description = "Whether you can use Aurora global databases with the engine version"
  value       = data.aws_rds_engine_version.this.supports_global_databases
}

output "supports_integrations" {
  description = "Whether the engine version supports integrations with other AWS services"
  value       = data.aws_rds_engine_version.this.supports_integrations
}

output "supports_log_exports_to_cloudwatch" {
  description = "Whether the engine version supports exporting the log types specified by exportable_log_types to CloudWatch Logs"
  value       = data.aws_rds_engine_version.this.supports_log_exports_to_cloudwatch
}

output "supports_local_write_forwarding" {
  description = "Whether the engine version supports local write forwarding or not"
  value       = data.aws_rds_engine_version.this.supports_local_write_forwarding
}

output "supports_limitless_database" {
  description = "Whether the engine version supports Aurora Limitless Database"
  value       = data.aws_rds_engine_version.this.supports_limitless_database
}

output "supports_parallel_query" {
  description = "Whether you can use Aurora parallel query with the engine version"
  value       = data.aws_rds_engine_version.this.supports_parallel_query
}

output "supports_read_replica" {
  description = "Whether the engine version supports read replicas"
  value       = data.aws_rds_engine_version.this.supports_read_replica
}

output "valid_major_targets" {
  description = "Set of versions that are valid major version upgrades for the engine version"
  value       = data.aws_rds_engine_version.this.valid_major_targets
}

output "valid_minor_targets" {
  description = "Set of versions that are valid minor version upgrades for the engine version"
  value       = data.aws_rds_engine_version.this.valid_minor_targets
}

output "valid_upgrade_targets" {
  description = "Set of versions that are valid major or minor upgrades for the engine version"
  value       = data.aws_rds_engine_version.this.valid_upgrade_targets
}

output "version_actual" {
  description = "Complete engine version"
  value       = data.aws_rds_engine_version.this.version_actual
}

output "version_description" {
  description = "Description of the engine version"
  value       = data.aws_rds_engine_version.this.version_description
}