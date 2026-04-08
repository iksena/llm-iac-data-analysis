resource "aws_medialive_input_security_group" "this" {
  dynamic "whitelist_rules" {
    for_each = var.whitelist_rules
    content {
      cidr = whitelist_rules.value.cidr
    }
  }

  region = var.region
  tags   = var.tags

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}