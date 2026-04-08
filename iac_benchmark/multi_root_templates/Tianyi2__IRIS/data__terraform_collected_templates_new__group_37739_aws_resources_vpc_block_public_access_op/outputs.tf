output "aws_account_id" {
  description = "The AWS account id to which these options apply."
  value       = aws_vpc_block_public_access_options.this.aws_account_id
}

output "aws_region" {
  description = "The AWS region to which these options apply."
  value       = aws_vpc_block_public_access_options.this.aws_region
}