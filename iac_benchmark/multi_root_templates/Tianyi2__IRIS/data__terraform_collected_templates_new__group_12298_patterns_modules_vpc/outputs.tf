resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.name}/vpc_id"
  type  = "String"
  value = module.vpc.vpc_id
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "private_subnets" {
  name  = "/${var.name}/private_subnets"
  type  = "StringList"
  value = join(",", module.vpc.private_subnets)
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}