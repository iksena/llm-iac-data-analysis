output "id" {
  description = "ASG name and key, separated by a comma (,)"
  value       = aws_autoscaling_group_tag.this.id
}