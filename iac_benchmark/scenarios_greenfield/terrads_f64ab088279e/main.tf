# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Copyright (c) Neferdata, Corp

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

# Filter out local zones, which are not currently supported 
# with managed node groups
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  cluster_name = "neferdata-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "education-vpc"

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }

  tags = {
    Name = "Neferdata"
  }
}

module "eks" {
  count = var.create_eks_cluster ? 1 : 0  # Conditionally create the EKS cluster
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = local.cluster_name
  cluster_version = "1.27"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }

    two = {
      name = "node-group-2"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }

  tags = {
    Name = "Neferdata"
  }
}


# https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/ 
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "irsa-ebs-csi" {
  count = var.create_eks_cluster ? 1 : 0
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "4.7.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks[0].cluster_name}"
  provider_url                  = module.eks[0].oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

# EKS 

resource "aws_eks_addon" "ebs-csi" {
  count = var.create_eks_cluster ? 1 : 0
  cluster_name             = module.eks[0].cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.20.0-eksbuild.1"
  service_account_role_arn = module.irsa-ebs-csi[0].iam_role_arn
  tags = {
    "eks_addon" = "ebs-csi"
    "terraform" = "true"
  }
}

resource "aws_db_subnet_group" "private_subnets" {
  name       = "private_subnets-group"
  subnet_ids  = module.vpc.private_subnets

  tags = {
    Name = "Neferdata"
  }
}

resource "aws_security_group" "postgres_sg" {
  name        = "my-postgres-sg"
  description = "Allow PostgreSQL traffic"
  vpc_id                         = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # WARNING: This allows all IP addresses. Adjust accordingly.
  }

  tags = {
    Name = "Neferdata"
  }
}

# Database

resource "aws_db_instance" "postgres" {
  count = var.create_rds_instance ? 1 : 0
  allocated_storage    = 20  # Adjust as needed
  storage_type         = "standard"
  engine               = "postgres"
  engine_version       = "15.4"  # Adjust as per your desired PostgreSQL version
  instance_class       = "db.t3.micro"  # Adjust as needed
  identifier           = "neferdata-api-db"
  username = var.db_username
  password = var.db_password
  skip_final_snapshot  = false  # Set this to `false` for production databases to ensure a snapshot before deletion

  vpc_security_group_ids = [aws_security_group.postgres_sg.id]
  db_subnet_group_name = aws_db_subnet_group.private_subnets.name
  multi_az               = false  # Set to true for higher availability

  tags = {
    Name = "Neferdata"
  }
}

# Elasticache - Redis

resource "aws_security_group" "elasticache" {
  name        = "elasticache"
  description = "Allow inbound traffic for ElastiCache Memcached"

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id                         = module.vpc.vpc_id
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redissubnetgroup"
  subnet_ids = module.vpc.private_subnets
  description = "ElastiCache subnet group"
  tags = {
    Name = "Neferdata"
  }
}

resource "aws_elasticache_cluster" "redis" {
  count = var.create_redis_cluster ? 1 : 0
  cluster_id      = "neferdata-redis"
  engine          = "redis"
  node_type       = "cache.t2.micro"
  num_cache_nodes = 1
  port            = 6379

  tags = {
    Name = "Neferdata"
  }
  subnet_group_name = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids = [aws_security_group.elasticache.id]
}

# ExternalDNS
resource "aws_iam_policy" "external_dns" {
  name        = "ExternalDNSRoute53"
  description = "Permissions for External-DNS to manage Route53 records"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets",
          "route53:ListHostedZones"
        ],
        "Resource": "*"
      }
    ]
  })
}

# TODO: use oidc
resource "aws_iam_role" "external_dns" {
  name = "eks-external-dns"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "eks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "external_dns" {
  policy_arn = aws_iam_policy.external_dns.arn
  # TODO: read from module
  role       = "node-group-1-eks-node-group-20230922122919196500000002"
}

resource "aws_iam_role" "cert_manager_route53" {
  name = "cert-manager-route53"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${var.region}.amazonaws.com/id/06C9C3DADC2054A1780E2915A7D0A0CA"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "oidc.eks.${var.region}.amazonaws.com/id/06C9C3DADC2054A1780E2915A7D0A0CA:sub" : "system:serviceaccount:${var.k8s_namespace}:cert-manager-route53"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cert_manager_route53_policy_attachment" {
  role       = aws_iam_role.cert_manager_route53.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess" # or your custom policy ARN
}

