output "id" {
  description = "The key for the cost allocation tag"
  value       = aws_ce_cost_allocation_tag.this.id
}

output "type" {
  description = "The type of cost allocation tag"
  value       = aws_ce_cost_allocation_tag.this.type
}