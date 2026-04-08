output "id" {
  description = "The name of the Device Fleet."
  value       = aws_sagemaker_device_fleet.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this Device Fleet."
  value       = aws_sagemaker_device_fleet.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_sagemaker_device_fleet.this.tags_all
}