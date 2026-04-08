output "tg_arn" {
  value = aws_lb_target_group.lb_target_group.arn
}

output "lb_sg" {
  value = aws_security_group.lb.id
}

output "endpoint" {
  value = aws_lb.lb.dns_name
}