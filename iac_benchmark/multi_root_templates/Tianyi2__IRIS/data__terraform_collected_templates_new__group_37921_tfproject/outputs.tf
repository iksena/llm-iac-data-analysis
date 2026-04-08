# VPC outputs:

output "vpc-id" {
  value = module.vpc.default_vpc_id
}

output "app-alb-url" {
  value = aws_alb.app_lb.dns_name
}