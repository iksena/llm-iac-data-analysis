output "current_region" {
  value = data.aws_region.current.name
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.id
}

# output "instance_public_ip" {
#   description = "Public IP of the EC2 instance"
#   value       = module.ec2.instance_public_ip
# }

output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}
