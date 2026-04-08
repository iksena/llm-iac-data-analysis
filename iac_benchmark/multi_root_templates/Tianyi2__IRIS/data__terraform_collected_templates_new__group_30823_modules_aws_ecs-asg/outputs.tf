output "arn" {
  value = aws_autoscaling_group.asg.arn
}

output "name" {
  value = aws_autoscaling_group.asg.name
}

output "sg" {
  value = aws_security_group.cluster.id
}