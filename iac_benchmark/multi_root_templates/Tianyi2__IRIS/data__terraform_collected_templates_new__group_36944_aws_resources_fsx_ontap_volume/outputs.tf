output "aggregate_configuration_total_constituents" {
  description = "The total amount of constituents for a FLEXGROUP volume. This would equal constituents_per_aggregate x aggregates."
  value       = try(aws_fsx_ontap_volume.this.aggregate_configuration[0].total_constituents, null)
}

output "arn" {
  description = "Amazon Resource Name of the volume."
  value       = aws_fsx_ontap_volume.this.arn
}

output "id" {
  description = "Identifier of the volume, e.g., fsvol-12345678"
  value       = aws_fsx_ontap_volume.this.id
}

output "file_system_id" {
  description = "Describes the file system for the volume, e.g. fs-12345679"
  value       = aws_fsx_ontap_volume.this.file_system_id
}

output "flexcache_endpoint_type" {
  description = "Specifies the FlexCache endpoint type of the volume, Valid values are NONE, ORIGIN, CACHE. Default value is NONE."
  value       = aws_fsx_ontap_volume.this.flexcache_endpoint_type
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_fsx_ontap_volume.this.tags_all
}

output "uuid" {
  description = "The Volume's UUID (universally unique identifier)."
  value       = aws_fsx_ontap_volume.this.uuid
}

output "volume_type" {
  description = "The type of volume, currently the only valid value is ONTAP."
  value       = aws_fsx_ontap_volume.this.volume_type
}