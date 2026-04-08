output "id" {
  description = "AWS Region."
  value       = data.aws_outposts_sites.this.id
}

output "ids" {
  description = "Set of Outposts Site identifiers."
  value       = data.aws_outposts_sites.this.ids
}