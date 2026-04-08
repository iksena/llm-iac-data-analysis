output "vpc_id" {
       description = "The ID of the VPC"
       value       = module.vpc.vpc_id
}
output "alb_dns_name" {
       description = "The DNS name of the Application Load Balancer"
       value       = module.alb.alb_dns_name
}
output "alb_arn" {
       description = "The ARN of the Application Load Balancer"
       value       = "https://${module.alb.alb_dns_name}" 
}
output "instance_ids" {
       description = "The IDs of the EC2 instances"
       value       = module.ec2.instance_ids
}
output "availability_zones" {
       description = "Availability Zones used"
       value = slice(data.aws_availability_zones.available.names, 0, 2)
}
