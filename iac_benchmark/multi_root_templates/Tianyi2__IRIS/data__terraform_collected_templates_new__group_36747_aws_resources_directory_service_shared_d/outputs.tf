output "id" {
  description = "Identifier of the shared directory."
  value       = aws_directory_service_shared_directory_accepter.this.id
}

output "method" {
  description = "Method used when sharing a directory (i.e., ORGANIZATIONS or HANDSHAKE)."
  value       = aws_directory_service_shared_directory_accepter.this.method
}

output "notes" {
  description = "Message sent by the directory owner to the directory consumer to help the directory consumer administrator determine whether to approve or reject the share invitation."
  value       = aws_directory_service_shared_directory_accepter.this.notes
}

output "owner_account_id" {
  description = "Account identifier of the directory owner."
  value       = aws_directory_service_shared_directory_accepter.this.owner_account_id
}

output "owner_directory_id" {
  description = "Identifier of the Managed Microsoft AD directory from the perspective of the directory owner."
  value       = aws_directory_service_shared_directory_accepter.this.owner_directory_id
}