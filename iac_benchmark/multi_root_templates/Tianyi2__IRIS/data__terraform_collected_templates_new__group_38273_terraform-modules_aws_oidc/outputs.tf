output "aws_iam_openid_connect_provider" {
  value       = aws_iam_openid_connect_provider.this.arn
  description = "The ARN of the OpenID Connector Provider"
}

output "aws_iam_role" {
  value       = aws_iam_role.this.arn
  description = "The ARN of the IAM role"
}