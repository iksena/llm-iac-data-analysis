output "vpc_prod_id" {
  value = module.vpc_prod.vpc_id
}

output "vpc_prod_public_subnet_cidrs" {
  value = module.vpc_prod.public_subnet_cidrs
}

output "vpc_prod_private_subnet_cidrs" {
  value = module.vpc_prod.private_subnet_cidrs
}