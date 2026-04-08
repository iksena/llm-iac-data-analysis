/*
 * Copyright (C) 2019 Risk Focus, Inc. - All Rights Reserved
 * You may use, distribute and modify this code under the
 * terms of the Apache License Version 2.0.
 * http://www.apache.org/licenses
 */

provider "kubernetes" {
  version     = "~>1.9"
  config_path = "${var.config_output_path}/kubeconfig_${local.cluster_name}"
}

data "aws_caller_identity" "current" {
}

data "aws_region" "current" {
}

locals {
  aws_region = data.aws_region.current.name
  vpc_name   = "${var.project_prefix}-vpc"

  vpc_tags = {
    Environment = "${var.project_prefix}-infra"
  }

  eks_tags = {
    Name        = "${var.project_prefix}-eks"
    Environment = "${var.project_prefix}-infra"
  }

  route53_tags = {
    Name        = "${var.project_prefix}-dns"
    Environment = "${var.project_prefix}-infra"
  }

  bastion_tags = {
    Name        = "${var.project_prefix}-eks-bastion"
    Environment = "${var.project_prefix}-infra"
  }

  // TODO update from API
  github_meta_hooks = [
    "192.30.252.0/22",
    "185.199.108.0/22",
    "140.82.112.0/20",
  ]

  // https://confluence.atlassian.com/bitbucket/what-are-the-bitbucket-cloud-ip-addresses-i-should-use-to-configure-my-corporate-firewall-343343385.html
  atlassian_inbound = [
    "18.205.93.0/25",
    "18.234.32.128/25",
    "13.52.5.0/25",
  ]
}
