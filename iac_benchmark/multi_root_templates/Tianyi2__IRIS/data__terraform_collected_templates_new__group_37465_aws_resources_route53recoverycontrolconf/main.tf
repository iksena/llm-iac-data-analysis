resource "aws_route53recoverycontrolconfig_safety_rule" "this" {
  control_panel_arn = var.control_panel_arn
  name              = var.name
  wait_period_ms    = var.wait_period_ms
  asserted_controls = length(var.asserted_controls) > 0 ? var.asserted_controls : null
  gating_controls   = length(var.gating_controls) > 0 ? var.gating_controls : null
  target_controls   = length(var.target_controls) > 0 ? var.target_controls : null

  rule_config {
    inverted  = var.rule_config.inverted
    threshold = var.rule_config.threshold
    type      = var.rule_config.type
  }
}