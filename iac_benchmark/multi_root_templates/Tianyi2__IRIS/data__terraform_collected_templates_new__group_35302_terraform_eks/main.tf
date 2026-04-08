module "security_groups" {
      source              = "./"
      vpc_id              = module.vpc.aws_vpc_id
}

module "eks_cluster" {
      source              = "./"
      cluster_name        = var.cluster_name
      private_subnet_ids  = module.network.private_subnet_ids
}

module "eks_nodes" {
      source              = "./"
      private_subnet_ids  = module.network.private_subnet_ids
}

