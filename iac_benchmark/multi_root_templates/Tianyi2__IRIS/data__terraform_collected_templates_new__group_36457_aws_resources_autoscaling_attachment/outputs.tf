# This resource exports no additional attributes according to the AWS provider documentation.
# The resource itself can be referenced as aws_autoscaling_attachment.this for dependencies.

output "id" {
  description = "The ID of the autoscaling attachment resource."
  value       = aws_autoscaling_attachment.this.id
}

output "autoscaling_group_name" {
  description = "The name of the Auto Scaling group."
  value       = aws_autoscaling_attachment.this.autoscaling_group_name
}

output "elb" {
  description = "The name of the ELB (if attached)."
  value       = aws_autoscaling_attachment.this.elb
}

output "lb_target_group_arn" {
  description = "The ARN of the load balancer target group (if attached)."
  value       = aws_autoscaling_attachment.this.lb_target_group_arn
}