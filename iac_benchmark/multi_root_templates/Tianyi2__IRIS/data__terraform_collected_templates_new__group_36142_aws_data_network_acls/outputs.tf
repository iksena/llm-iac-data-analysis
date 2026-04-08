output "id" {
  description = "AWS Region."
  value       = data.aws_network_acls.this.id
}

output "ids" {
  description = "List of all the network ACL ids found."
  value       = data.aws_network_acls.this.ids
}