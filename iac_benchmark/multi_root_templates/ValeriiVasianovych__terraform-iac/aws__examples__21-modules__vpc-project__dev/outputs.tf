output "vpc_dev_id" {
  value = module.vpc_dev.vpc_id
}

output "vpc_dev_public_subnet_cidrs" {
  value = module.vpc_dev.public_subnet_cidrs
}

output "vpc_dev_private_subnet_cidrs" {
  value = module.vpc_dev.private_subnet_cidrs
}