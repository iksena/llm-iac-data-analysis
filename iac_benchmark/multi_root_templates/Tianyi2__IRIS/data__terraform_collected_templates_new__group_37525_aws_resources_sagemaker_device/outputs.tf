output "id" {
  description = "The id is constructed from device-fleet-name/device-name."
  value       = aws_sagemaker_device.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this Device."
  value       = aws_sagemaker_device.this.arn
}