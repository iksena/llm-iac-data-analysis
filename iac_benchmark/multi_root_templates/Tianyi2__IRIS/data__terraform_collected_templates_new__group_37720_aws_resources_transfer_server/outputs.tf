output "arn" {
  description = "Amazon Resource Name (ARN) of Transfer Server"
  value       = aws_transfer_server.this.arn
}

output "id" {
  description = "The Server ID of the Transfer Server (e.g., s-12345678)"
  value       = aws_transfer_server.this.id
}

output "endpoint" {
  description = "The endpoint of the Transfer Server (e.g., s-12345678.server.transfer.REGION.amazonaws.com)"
  value       = aws_transfer_server.this.endpoint
}

output "host_key_fingerprint" {
  description = "This value contains the message-digest algorithm (MD5) hash of the server's host key. This value is equivalent to the output of the ssh-keygen -l -E md5 -f my-new-server-key command."
  value       = aws_transfer_server.this.host_key_fingerprint
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_transfer_server.this.tags_all
}