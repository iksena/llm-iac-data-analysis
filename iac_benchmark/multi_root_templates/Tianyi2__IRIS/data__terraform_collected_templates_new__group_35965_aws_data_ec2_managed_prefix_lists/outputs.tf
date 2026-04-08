output "id" {
  description = "AWS Region"
  value       = data.aws_ec2_managed_prefix_lists.this.id
}

output "ids" {
  description = "List of all the managed prefix list ids found"
  value       = data.aws_ec2_managed_prefix_lists.this.ids
}