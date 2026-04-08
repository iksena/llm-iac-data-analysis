output "arn" {
  description = "ARN of the VPC connection."
  value       = aws_quicksight_vpc_connection.this.arn
}

output "availability_status" {
  description = "The availability status of the VPC connection. Valid values are AVAILABLE, UNAVAILABLE or PARTIALLY_AVAILABLE."
  value       = aws_quicksight_vpc_connection.this.availability_status
}

output "id" {
  description = "A comma-delimited string joining AWS account ID and VPC connection ID."
  value       = aws_quicksight_vpc_connection.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_quicksight_vpc_connection.this.tags_all
}