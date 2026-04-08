output "id" {
  description = "Snapshot ID"
  value       = data.aws_db_snapshot.this.id
}

output "allocated_storage" {
  description = "Allocated storage size in gigabytes (GB)"
  value       = data.aws_db_snapshot.this.allocated_storage
}

output "availability_zone" {
  description = "Name of the Availability Zone the DB instance was located in at the time of the DB snapshot"
  value       = data.aws_db_snapshot.this.availability_zone
}

output "db_snapshot_arn" {
  description = "ARN for the DB snapshot"
  value       = data.aws_db_snapshot.this.db_snapshot_arn
}

output "encrypted" {
  description = "Whether the DB snapshot is encrypted"
  value       = data.aws_db_snapshot.this.encrypted
}

output "engine" {
  description = "Name of the database engine"
  value       = data.aws_db_snapshot.this.engine
}

output "engine_version" {
  description = "Version of the database engine"
  value       = data.aws_db_snapshot.this.engine_version
}

output "iops" {
  description = "Provisioned IOPS (I/O operations per second) value of the DB instance at the time of the snapshot"
  value       = data.aws_db_snapshot.this.iops
}

output "kms_key_id" {
  description = "ARN for the KMS encryption key"
  value       = data.aws_db_snapshot.this.kms_key_id
}

output "license_model" {
  description = "License model information for the restored DB instance"
  value       = data.aws_db_snapshot.this.license_model
}

output "option_group_name" {
  description = "Provides the option group name for the DB snapshot"
  value       = data.aws_db_snapshot.this.option_group_name
}

output "source_db_snapshot_identifier" {
  description = "DB snapshot ARN that the DB snapshot was copied from"
  value       = data.aws_db_snapshot.this.source_db_snapshot_identifier
}

output "source_region" {
  description = "Region that the DB snapshot was created in or copied from"
  value       = data.aws_db_snapshot.this.source_region
}

output "status" {
  description = "Status of this DB snapshot"
  value       = data.aws_db_snapshot.this.status
}

output "storage_type" {
  description = "Storage type associated with DB snapshot"
  value       = data.aws_db_snapshot.this.storage_type
}

output "vpc_id" {
  description = "ID of the VPC associated with the DB snapshot"
  value       = data.aws_db_snapshot.this.vpc_id
}

output "snapshot_create_time" {
  description = "Provides the time when the snapshot was taken, in Universal Coordinated Time (UTC)"
  value       = data.aws_db_snapshot.this.snapshot_create_time
}

output "original_snapshot_create_time" {
  description = "Provides the time when the snapshot was taken, in Universal Coordinated Time (UTC)"
  value       = data.aws_db_snapshot.this.original_snapshot_create_time
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_db_snapshot.this.region
}

output "most_recent" {
  description = "If more than one result is returned, use the most recent Snapshot"
  value       = var.most_recent
}

output "db_instance_identifier" {
  description = "Returns the list of snapshots created by the specific db_instance"
  value       = var.db_instance_identifier
}

output "db_snapshot_identifier" {
  description = "Returns information on a specific snapshot_id"
  value       = var.db_snapshot_identifier
}

output "snapshot_type" {
  description = "Type of snapshots to be returned"
  value       = var.snapshot_type
}

output "include_shared" {
  description = "Set this value to true to include shared manual DB snapshots from other AWS accounts"
  value       = var.include_shared
}

output "include_public" {
  description = "Set this value to true to include manual DB snapshots that are public and can be copied or restored by any AWS account"
  value       = var.include_public
}

output "tags" {
  description = "Mapping of tags, each pair of which must exactly match a pair on the desired DB snapshot"
  value       = var.tags
}