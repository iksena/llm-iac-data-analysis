output "id" {
  description = "Amazon Resource Name (ARN) of the NFS File Share."
  value       = aws_storagegateway_nfs_file_share.this.id
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the NFS File Share."
  value       = aws_storagegateway_nfs_file_share.this.arn
}

output "fileshare_id" {
  description = "ID of the NFS File Share."
  value       = aws_storagegateway_nfs_file_share.this.fileshare_id
}

output "path" {
  description = "File share path used by the NFS client to identify the mount point."
  value       = aws_storagegateway_nfs_file_share.this.path
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_storagegateway_nfs_file_share.this.tags_all
}