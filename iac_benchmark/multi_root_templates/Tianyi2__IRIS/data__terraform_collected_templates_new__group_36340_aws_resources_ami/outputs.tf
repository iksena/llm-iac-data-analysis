output "arn" {
  description = "ARN of the AMI"
  value       = aws_ami.this.arn
}

output "id" {
  description = "ID of the created AMI"
  value       = aws_ami.this.id
}

output "owner_id" {
  description = "AWS account ID of the image owner"
  value       = aws_ami.this.owner_id
}

output "root_snapshot_id" {
  description = "Snapshot ID for the root volume (for EBS-backed AMIs)"
  value       = aws_ami.this.root_snapshot_id
}

output "usage_operation" {
  description = "Operation of the Amazon EC2 instance and the billing code that is associated with the AMI"
  value       = aws_ami.this.usage_operation
}

output "platform_details" {
  description = "Platform details associated with the billing code of the AMI"
  value       = aws_ami.this.platform_details
}

output "image_owner_alias" {
  description = "AWS account alias or the AWS account ID of the AMI owner"
  value       = aws_ami.this.image_owner_alias
}

output "image_type" {
  description = "Type of image"
  value       = aws_ami.this.image_type
}

output "hypervisor" {
  description = "Hypervisor type of the image"
  value       = aws_ami.this.hypervisor
}

output "platform" {
  description = "Platform - set to windows for Windows AMIs, otherwise blank"
  value       = aws_ami.this.platform
}

output "public" {
  description = "Whether the image has public launch permissions"
  value       = aws_ami.this.public
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_ami.this.tags_all
}

output "last_launched_time" {
  description = "Date and time when the AMI was last used to launch an EC2 instance"
  value       = aws_ami.this.last_launched_time
}