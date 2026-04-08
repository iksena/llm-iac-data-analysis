output "id" {
  description = "The ID of the egress-only Internet gateway."
  value       = aws_egress_only_internet_gateway.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_egress_only_internet_gateway.this.tags_all
}