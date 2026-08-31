output "delegation_set_id" {
  description = "Use this ID in the website_contents terraform"
  value       = aws_route53_delegation_set.name_servers.id
}

output "delegation_set_name_servers" {
  description = "Set these servers for the registered domain"
  value       = aws_route53_delegation_set.name_servers.name_servers
}

resource "aws_ssm_parameter" "delegation_set_id" {
  name  = "${local.prefix_parameter}/Route53/DelegationSetId"
  type  = "String"
  value = aws_route53_delegation_set.name_servers.id
}