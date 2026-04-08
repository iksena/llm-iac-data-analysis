output "id" {
  description = "AWS account ID."
  value       = aws_servicequotas_template_association.this.id
}

output "status" {
  description = "Association status. Creating this resource will result in an ASSOCIATED status, and quota increase requests in the template are automatically applied to new AWS accounts in the organization."
  value       = aws_servicequotas_template_association.this.status
}