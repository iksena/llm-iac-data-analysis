output "name" {
  description = "Name of the S3 access point."
  value       = aws_fsx_s3_access_point_attachment.this.name
}

output "type" {
  description = "Type of S3 access point."
  value       = aws_fsx_s3_access_point_attachment.this.type
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_fsx_s3_access_point_attachment.this.region
}

output "openzfs_configuration" {
  description = "Configuration used when creating and attaching an S3 access point to an FSx for OpenZFS volume."
  value       = aws_fsx_s3_access_point_attachment.this.openzfs_configuration
}

output "s3_access_point" {
  description = "S3 access point configuration."
  value       = aws_fsx_s3_access_point_attachment.this.s3_access_point
}

output "s3_access_point_alias" {
  description = "S3 access point's alias."
  value       = aws_fsx_s3_access_point_attachment.this.s3_access_point_alias
}

output "s3_access_point_arn" {
  description = "S3 access point's ARN."
  value       = aws_fsx_s3_access_point_attachment.this.s3_access_point_arn
}

output "timeouts" {
  description = "Timeouts configuration."
  value       = aws_fsx_s3_access_point_attachment.this.timeouts
}