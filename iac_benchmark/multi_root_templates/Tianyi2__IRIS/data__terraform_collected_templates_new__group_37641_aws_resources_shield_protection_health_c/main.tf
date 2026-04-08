resource "aws_shield_protection_health_check_association" "this" {
  health_check_arn     = var.health_check_arn
  shield_protection_id = var.shield_protection_id
}