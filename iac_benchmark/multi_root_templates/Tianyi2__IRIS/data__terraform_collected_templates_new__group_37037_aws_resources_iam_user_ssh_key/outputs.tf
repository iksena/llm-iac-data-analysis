output "ssh_public_key_id" {
  description = "The unique identifier for the SSH public key."
  value       = aws_iam_user_ssh_key.this.ssh_public_key_id
}

output "fingerprint" {
  description = "The MD5 message digest of the SSH public key."
  value       = aws_iam_user_ssh_key.this.fingerprint
}

output "username" {
  description = "The name of the IAM user to associate the SSH public key with."
  value       = aws_iam_user_ssh_key.this.username
}

output "encoding" {
  description = "Specifies the public key encoding format to use in the response."
  value       = aws_iam_user_ssh_key.this.encoding
}

output "public_key" {
  description = "The SSH public key."
  value       = aws_iam_user_ssh_key.this.public_key
  sensitive   = true
}

output "status" {
  description = "The status to assign to the SSH public key."
  value       = aws_iam_user_ssh_key.this.status
}