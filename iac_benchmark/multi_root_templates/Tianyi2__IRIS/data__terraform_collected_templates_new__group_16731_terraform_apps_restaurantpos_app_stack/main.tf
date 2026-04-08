terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  common_tags = {
    Environment = var.environment
    Project     = "dotnet-starter-kit"
  }
  aspnetcore_environment = var.environment == "dev" ? "Development" : "Production"
}

module "network" {
  source = "../../../modules/network"

  name       = "${var.environment}-${var.region}"
  cidr_block = var.vpc_cidr_block

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  tags = local.common_tags
}

module "ecs_cluster" {
  source = "../../../modules/ecs_cluster"

  name = "${var.environment}-${var.region}-cluster"
}

resource "aws_security_group" "alb" {
  name        = "${var.environment}-${var.region}-alb"
  description = "ALB security group"
  vpc_id      = module.network.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

module "alb" {
  source = "../../../modules/alb"

  name              = "${var.environment}-${var.region}-alb"
  subnet_ids        = module.network.public_subnet_ids
  security_group_id = aws_security_group.alb.id
  tags              = local.common_tags
}

module "app_s3" {
  source = "../../../modules/s3_bucket"

  name = var.app_s3_bucket_name
  tags = local.common_tags
}

module "rds" {
  source = "../../../modules/rds_postgres"

  name                       = "${var.environment}-${var.region}-postgres"
  vpc_id                     = module.network.vpc_id
  subnet_ids                 = module.network.private_subnet_ids
  allowed_security_group_ids = [
    module.api_service.security_group_id,
    module.blazor_service.security_group_id,
  ]
  db_name                    = var.db_name
  username                   = var.db_username
  password                   = var.db_password
  tags                       = local.common_tags
}

locals {
  db_connection_string = "Host=${module.rds.endpoint};Port=${module.rds.port};Database=${var.db_name};Username=${var.db_username};Password=${var.db_password};Pooling=true;"
}

module "redis" {
  source = "../../../modules/elasticache_redis"

  name                       = "${var.environment}-${var.region}-redis"
  vpc_id                     = module.network.vpc_id
  subnet_ids                 = module.network.private_subnet_ids
  allowed_security_group_ids = [
    module.api_service.security_group_id,
    module.blazor_service.security_group_id,
  ]
  tags                       = local.common_tags
}

module "api_service" {
  source = "../../../modules/ecs_service"

  name            = "${var.environment}-api"
  region          = var.region
  cluster_arn     = module.ecs_cluster.arn
  container_image = var.api_container_image
  container_port  = var.api_container_port
  cpu             = var.api_cpu
  memory          = var.api_memory
  desired_count   = var.api_desired_count

  vpc_id          = module.network.vpc_id
  vpc_cidr_block  = module.network.vpc_cidr_block
  subnet_ids      = module.network.private_subnet_ids
  assign_public_ip = false

  listener_arn           = module.alb.listener_arn
  listener_rule_priority = 10
  path_patterns          = ["/api/*", "/scalar*", "/health*", "/swagger*", "/openapi*"]

  health_check_path = "/health/live"

  environment_variables = {
    ASPNETCORE_ENVIRONMENT            = local.aspnetcore_environment
    DatabaseOptions__ConnectionString = local.db_connection_string
    CachingOptions__Redis             = "${module.redis.primary_endpoint_address}:6379,ssl=True,abortConnect=False"
  }

  tags = local.common_tags
}

module "blazor_service" {
  source = "../../../modules/ecs_service"

  name            = "${var.environment}-blazor"
  region          = var.region
  cluster_arn     = module.ecs_cluster.arn
  container_image = var.blazor_container_image
  container_port  = var.blazor_container_port
  cpu             = var.blazor_cpu
  memory          = var.blazor_memory
  desired_count   = var.blazor_desired_count

  vpc_id          = module.network.vpc_id
  vpc_cidr_block  = module.network.vpc_cidr_block
  subnet_ids      = module.network.private_subnet_ids
  assign_public_ip = false

  listener_arn           = module.alb.listener_arn
  listener_rule_priority = 20
  path_patterns          = ["/*"]

  health_check_path = "/health/live"

  environment_variables = {
    ASPNETCORE_ENVIRONMENT = local.aspnetcore_environment
    Api__BaseUrl           = "http://${module.alb.dns_name}"
  }

  tags = local.common_tags
}

output "alb_dns_name" {
  value = module.alb.dns_name
}

output "api_url" {
  value = "http://${module.alb.dns_name}/api"
}

output "blazor_url" {
  value = "http://${module.alb.dns_name}"
}

output "rds_endpoint" {
  value = module.rds.endpoint
}

output "redis_endpoint" {
  value = module.redis.primary_endpoint_address
}
