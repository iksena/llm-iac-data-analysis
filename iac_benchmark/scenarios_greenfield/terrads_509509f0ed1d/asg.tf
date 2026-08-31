resource "aws_autoscaling_group" "weasel_crm_asg" {
  name             = "weasel-crm-asg"
  max_size         = var.max_size
  min_size         = var.min_size
  desired_capacity = var.desired_capacity
  force_delete     = true

  launch_template {
    id = aws_launch_template.weasel_crm_lt.id
  }

  vpc_zone_identifier = [
    aws_subnet.weasel_crm_public1.id,
    aws_subnet.weasel_crm_public2.id,
    aws_subnet.weasel_crm_public3.id,
  ]
}