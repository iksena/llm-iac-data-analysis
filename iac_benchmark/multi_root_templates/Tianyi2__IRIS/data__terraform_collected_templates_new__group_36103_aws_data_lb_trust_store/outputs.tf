output "arn" {
  description = "Full ARN of the trust store."
  value       = data.aws_lb_trust_store.this.arn
}

output "name" {
  description = "Unique name of the trust store."
  value       = data.aws_lb_trust_store.this.name
}

output "region" {
  description = "Region where the trust store is located."
  value       = data.aws_lb_trust_store.this.region
}

output "id" {
  description = "ID of the trust store."
  value       = data.aws_lb_trust_store.this.id
}

