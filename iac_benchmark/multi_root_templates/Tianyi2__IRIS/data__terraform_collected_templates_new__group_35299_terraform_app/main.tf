
module "app-namespace" {
      source              = "./"
}

module "app-services" {
      source              = "./"
}

module "app-deployment" {
      source              = "./"
}

module "app-ingress" {
      source              = "./"
}

module "rbac-role" {
      source              = "./"
}

module "alb-ingress-controller" {
      source              = "./"
      region              = var.aws_region
      vpc_id              = module.vpc.aws_vpc_id
}

