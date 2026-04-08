output "provisioned_model_arn" {
  description = "The ARN of the Provisioned Throughput."
  value       = aws_bedrock_provisioned_model_throughput.this.provisioned_model_arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_bedrock_provisioned_model_throughput.this.tags_all
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_bedrock_provisioned_model_throughput.this.region
}

output "commitment_duration" {
  description = "Commitment duration for the Provisioned Throughput."
  value       = aws_bedrock_provisioned_model_throughput.this.commitment_duration
}

output "model_arn" {
  description = "ARN of the model associated with this Provisioned Throughput."
  value       = aws_bedrock_provisioned_model_throughput.this.model_arn
}

output "model_units" {
  description = "Number of model units allocated."
  value       = aws_bedrock_provisioned_model_throughput.this.model_units
}

output "provisioned_model_name" {
  description = "Name of this Provisioned Throughput."
  value       = aws_bedrock_provisioned_model_throughput.this.provisioned_model_name
}

output "tags" {
  description = "Map of tags assigned to the resource."
  value       = aws_bedrock_provisioned_model_throughput.this.tags
}