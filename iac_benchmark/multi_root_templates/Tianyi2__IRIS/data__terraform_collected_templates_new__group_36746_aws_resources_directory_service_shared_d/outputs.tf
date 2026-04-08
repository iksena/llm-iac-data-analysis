output "id" {
  description = "Identifier of the shared directory"
  value       = aws_directory_service_shared_directory.this.id
}

output "shared_directory_id" {
  description = "Identifier of the directory that is stored in the directory consumer account that corresponds to the shared directory in the owner account"
  value       = aws_directory_service_shared_directory.this.shared_directory_id
}