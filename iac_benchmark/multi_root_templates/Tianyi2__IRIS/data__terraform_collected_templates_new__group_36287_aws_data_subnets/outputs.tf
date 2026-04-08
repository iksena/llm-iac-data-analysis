output "ids" {
  description = "List of all the subnet ids found"
  value       = data.aws_subnets.this.ids
}