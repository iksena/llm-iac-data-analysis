output "id" {
  description = "AWS Region"
  value       = data.aws_ebs_volumes.this.id
}

output "ids" {
  description = "Set of all the EBS Volume IDs found"
  value       = data.aws_ebs_volumes.this.ids
}