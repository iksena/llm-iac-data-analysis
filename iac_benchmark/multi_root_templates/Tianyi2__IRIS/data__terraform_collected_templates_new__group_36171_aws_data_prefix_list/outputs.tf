output "id" {
  description = "ID of the selected prefix list."
  value       = data.aws_prefix_list.this.id
}

output "name" {
  description = "Name of the selected prefix list."
  value       = data.aws_prefix_list.this.name
}

output "cidr_blocks" {
  description = "List of CIDR blocks for the AWS service associated with the prefix list."
  value       = data.aws_prefix_list.this.cidr_blocks
}