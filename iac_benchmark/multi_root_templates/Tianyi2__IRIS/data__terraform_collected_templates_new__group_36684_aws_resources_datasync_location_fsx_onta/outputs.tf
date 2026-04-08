output "arn" {
  description = "ARN of the DataSync Location for the FSx Ontap File System"
  value       = aws_datasync_location_fsx_ontap_file_system.this.arn
}

output "fsx_filesystem_arn" {
  description = "ARN of the FSx Ontap File System"
  value       = aws_datasync_location_fsx_ontap_file_system.this.fsx_filesystem_arn
}

output "uri" {
  description = "URI of the FSx ONTAP file system location"
  value       = aws_datasync_location_fsx_ontap_file_system.this.uri
}