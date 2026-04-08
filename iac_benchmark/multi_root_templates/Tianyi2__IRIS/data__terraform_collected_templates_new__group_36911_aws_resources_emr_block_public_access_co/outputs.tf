output "id" {
  description = "The ID of the EMR Block Public Access Configuration"
  value       = aws_emr_block_public_access_configuration.this.id
}

output "block_public_security_group_rules" {
  description = "Whether EMR Block Public Access is enabled"
  value       = aws_emr_block_public_access_configuration.this.block_public_security_group_rules
}

output "region" {
  description = "The AWS region where this configuration is managed"
  value       = aws_emr_block_public_access_configuration.this.region
}

output "permitted_public_security_group_rule_ranges" {
  description = "The configured permitted public security group rule port ranges"
  value       = aws_emr_block_public_access_configuration.this.permitted_public_security_group_rule_range
}