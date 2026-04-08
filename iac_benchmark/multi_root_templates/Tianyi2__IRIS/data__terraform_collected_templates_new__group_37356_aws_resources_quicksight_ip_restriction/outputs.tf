output "aws_account_id" {
  description = "AWS account ID"
  value       = aws_quicksight_ip_restriction.this.aws_account_id
}

output "enabled" {
  description = "Whether IP rules are turned on"
  value       = aws_quicksight_ip_restriction.this.enabled
}

output "ip_restriction_rule_map" {
  description = "Map of allowed IPv4 CIDR ranges and descriptions"
  value       = aws_quicksight_ip_restriction.this.ip_restriction_rule_map
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_quicksight_ip_restriction.this.region
}

output "vpc_endpoint_id_restriction_rule_map" {
  description = "Map of allowed VPC endpoint IDs and descriptions"
  value       = aws_quicksight_ip_restriction.this.vpc_endpoint_id_restriction_rule_map
}

output "vpc_id_restriction_rule_map" {
  description = "Map of VPC IDs and descriptions"
  value       = aws_quicksight_ip_restriction.this.vpc_id_restriction_rule_map
}