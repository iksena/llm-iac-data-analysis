output "default_character_set" {
  description = "Default character set for the engine version."
  value       = data.aws_neptune_engine_version.this.default_character_set
}

output "engine" {
  description = "DB engine."
  value       = data.aws_neptune_engine_version.this.engine
}

output "engine_description" {
  description = "Description of the database engine."
  value       = data.aws_neptune_engine_version.this.engine_description
}

output "exportable_log_types" {
  description = "Set of log types that the database engine has available for export to CloudWatch Logs."
  value       = data.aws_neptune_engine_version.this.exportable_log_types
}

output "supported_character_sets" {
  description = "Set of character sets supported by this engine version."
  value       = data.aws_neptune_engine_version.this.supported_character_sets
}

output "supported_timezones" {
  description = "Set of time zones supported by this engine."
  value       = data.aws_neptune_engine_version.this.supported_timezones
}

output "supports_global_databases" {
  description = "Whether the engine version supports global databases."
  value       = data.aws_neptune_engine_version.this.supports_global_databases
}

output "supports_log_exports_to_cloudwatch" {
  description = "Whether the engine version supports exporting the log types specified by `exportable_log_types` to CloudWatch Logs."
  value       = data.aws_neptune_engine_version.this.supports_log_exports_to_cloudwatch
}

output "supports_read_replica" {
  description = "Whether the database engine version supports read replicas."
  value       = data.aws_neptune_engine_version.this.supports_read_replica
}

output "valid_major_targets" {
  description = "Set of valid major engine versions that this version can be upgraded to."
  value       = data.aws_neptune_engine_version.this.valid_major_targets
}

output "valid_minor_targets" {
  description = "Set of valid minor engine versions that this version can be upgraded to."
  value       = data.aws_neptune_engine_version.this.valid_minor_targets
}

output "valid_upgrade_targets" {
  description = "Set of engine versions that this database engine version can be upgraded to."
  value       = data.aws_neptune_engine_version.this.valid_upgrade_targets
}

output "version" {
  description = "Version of the DB engine."
  value       = data.aws_neptune_engine_version.this.version
}

output "version_actual" {
  description = "Actual engine version returned by the API."
  value       = data.aws_neptune_engine_version.this.version_actual
}

output "version_description" {
  description = "Description of the database engine version."
  value       = data.aws_neptune_engine_version.this.version_description
}