# ASG lifecycle hook
resource "aws_autoscaling_lifecycle_hook" "asg_hook" {
  name                   = "lambda-eni-attach"
  autoscaling_group_name = "${var.asg_name}"
  default_result         = "${var.lifecycle_hook_default_result}"
  heartbeat_timeout      = "${var.lifecycle_hook_heartbeat_timeout}"
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_LAUNCHING"
}
