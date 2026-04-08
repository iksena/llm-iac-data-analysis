output "arn" {
  description = "Amazon Resource Name (ARN) of the VPC connection."
  value       = aws_msk_vpc_connection.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_msk_vpc_connection.this.tags_all
}