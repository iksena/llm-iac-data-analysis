output "arn" {
  description = "The Amazon Resource Name (ARN) of the Delegation Set"
  value       = aws_route53_delegation_set.this.arn
}

output "id" {
  description = "The delegation set ID"
  value       = aws_route53_delegation_set.this.id
}

output "name_servers" {
  description = "A list of authoritative name servers for the hosted zone (effectively a list of NS records)"
  value       = aws_route53_delegation_set.this.name_servers
}