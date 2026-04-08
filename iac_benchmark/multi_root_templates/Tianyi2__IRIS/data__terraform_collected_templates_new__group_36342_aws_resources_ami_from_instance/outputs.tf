output "arn" {
  description = "ARN of the AMI."
  value       = aws_ami_from_instance.this.arn
}

output "id" {
  description = "ID of the created AMI."
  value       = aws_ami_from_instance.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_ami_from_instance.this.region
}

output "name" {
  description = "Region-unique name for the AMI."
  value       = aws_ami_from_instance.this.name
}

output "source_instance_id" {
  description = "ID of the instance used as the basis of the AMI."
  value       = aws_ami_from_instance.this.source_instance_id
}

output "snapshot_without_reboot" {
  description = "Boolean that overrides the behavior of stopping the instance before snapshotting."
  value       = aws_ami_from_instance.this.snapshot_without_reboot
}

output "tags" {
  description = "Map of tags assigned to the resource."
  value       = aws_ami_from_instance.this.tags
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ami_from_instance.this.tags_all
}