resource "aws_emr_block_public_access_configuration" "this" {
  block_public_security_group_rules = var.block_public_security_group_rules
  region                            = var.region

  dynamic "permitted_public_security_group_rule_range" {
    for_each = var.permitted_public_security_group_rule_ranges
    content {
      min_range = permitted_public_security_group_rule_range.value.min_range
      max_range = permitted_public_security_group_rule_range.value.max_range
    }
  }
}