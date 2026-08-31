output "ip_set_arn" {
  value = var.trusted_ips == "" ? "" : aws_wafv2_ip_set.trusted[0].arn
}

output "rule_group_arn" {
  value = aws_wafv2_rule_group.rule_group.arn
}
