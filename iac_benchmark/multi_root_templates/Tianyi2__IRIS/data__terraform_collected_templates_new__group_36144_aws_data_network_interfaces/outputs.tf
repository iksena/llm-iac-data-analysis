output "id" {
  description = "AWS Region."
  value       = data.aws_network_interfaces.this.id
}

output "ids" {
  description = "List of all the network interface ids found."
  value       = data.aws_network_interfaces.this.ids
}