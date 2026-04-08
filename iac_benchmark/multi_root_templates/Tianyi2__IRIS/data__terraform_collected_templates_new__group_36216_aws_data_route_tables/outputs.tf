output "id" {
  description = "AWS Region."
  value       = data.aws_route_tables.this.id
}

output "ids" {
  description = "List of all the route table ids found."
  value       = data.aws_route_tables.this.ids
}