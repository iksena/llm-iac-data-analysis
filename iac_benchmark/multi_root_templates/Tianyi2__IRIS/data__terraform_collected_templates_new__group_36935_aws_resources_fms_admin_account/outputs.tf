output "id" {
  description = "The AWS account ID of the AWS Firewall Manager administrator account"
  value       = aws_fms_admin_account.this.id
}