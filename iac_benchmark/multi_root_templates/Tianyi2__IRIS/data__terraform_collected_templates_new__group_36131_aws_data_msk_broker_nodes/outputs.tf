output "node_info_list" {
  description = "List of MSK Broker Nodes, sorted by broker ID in ascending order"
  value       = data.aws_msk_broker_nodes.this.node_info_list
}

output "attached_eni_id" {
  description = "List of attached elastic network interfaces of the brokers"
  value       = [for node in data.aws_msk_broker_nodes.this.node_info_list : node.attached_eni_id]
}

output "broker_id" {
  description = "List of broker IDs"
  value       = [for node in data.aws_msk_broker_nodes.this.node_info_list : node.broker_id]
}

output "client_subnet" {
  description = "List of client subnets to which broker nodes belong"
  value       = [for node in data.aws_msk_broker_nodes.this.node_info_list : node.client_subnet]
}

output "client_vpc_ip_address" {
  description = "List of client virtual private cloud (VPC) IP addresses"
  value       = [for node in data.aws_msk_broker_nodes.this.node_info_list : node.client_vpc_ip_address]
}

output "endpoints" {
  description = "List of sets of endpoints for accessing the brokers"
  value       = [for node in data.aws_msk_broker_nodes.this.node_info_list : node.endpoints]
}

output "node_arn" {
  description = "List of ARNs of the nodes"
  value       = [for node in data.aws_msk_broker_nodes.this.node_info_list : node.node_arn]
}