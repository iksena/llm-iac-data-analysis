output "arn" {
  description = "ARN of the AMI."
  value       = aws_ami_copy.this.arn
}

output "id" {
  description = "ID of the created AMI."
  value       = aws_ami_copy.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_ami_copy.this.region
}

output "name" {
  description = "Region-unique name for the AMI."
  value       = aws_ami_copy.this.name
}

output "source_ami_id" {
  description = "Id of the AMI that was copied."
  value       = aws_ami_copy.this.source_ami_id
}

output "source_ami_region" {
  description = "Region from which the AMI was copied."
  value       = aws_ami_copy.this.source_ami_region
}

output "destination_outpost_arn" {
  description = "ARN of the Outpost to which the AMI was copied."
  value       = aws_ami_copy.this.destination_outpost_arn
}

output "encrypted" {
  description = "Whether the destination snapshots of the copied image are encrypted."
  value       = aws_ami_copy.this.encrypted
}

output "kms_key_id" {
  description = "Full ARN of the KMS Key used when encrypting the snapshots."
  value       = aws_ami_copy.this.kms_key_id
}

output "tags" {
  description = "Map of tags assigned to the resource."
  value       = aws_ami_copy.this.tags
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ami_copy.this.tags_all
}