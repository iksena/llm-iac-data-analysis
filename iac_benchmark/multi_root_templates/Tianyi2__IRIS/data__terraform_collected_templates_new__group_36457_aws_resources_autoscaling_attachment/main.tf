locals {
  validate_attachment_type = (var.elb != null && var.lb_target_group_arn == null) || (var.elb == null && var.lb_target_group_arn != null) ? true : tobool("Exactly one of elb or lb_target_group_arn must be specified")
}

resource "aws_autoscaling_attachment" "this" {
  region                 = var.region
  autoscaling_group_name = var.autoscaling_group_name
  elb                    = var.elb
  lb_target_group_arn    = var.lb_target_group_arn

  depends_on = [local.validate_attachment_type]
}