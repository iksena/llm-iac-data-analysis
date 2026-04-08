output "ec2_asg_name" {
  description = "Name of the EC2 Auto Scaling Group"
  value       = module.ec2_autoscale.autoscaling_group_name
}

output "application_load_balancer_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.load_balancer.load_balancer_dns_name
}

output "load_balancer_security_group_id" {
  description = "ID of the security group for the load balancer"
  value       = module.load_balancer.security_group_id
}

output "subnet_ids" {
  description = "ID of the first subnet"
  value       = module.subnets.subnet_ids
}

output "route_table_id" {
  description = "The ID of the route table."
  value       = module.domain_routing.route_table_id
}

output "frontend_record_name" {
  description = "The fully qualified domain name of the frontend record in Route 53."
  value       = module.domain_routing.frontend_record_name
}

