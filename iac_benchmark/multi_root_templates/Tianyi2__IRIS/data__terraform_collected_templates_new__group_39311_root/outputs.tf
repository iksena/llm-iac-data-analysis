/*
 * Copyright (C) 2019 Risk Focus, Inc. - All Rights Reserved
 * You may use, distribute and modify this code under the
 * terms of the Apache License Version 2.0.
 * http://www.apache.org/licenses
 */

output "kubeconfig_filename" {
  value = module.eks.kubeconfig_filename
}

output "whitelist_sg_id" {
  value = aws_security_group.whitelist.id
}

output "vpc" {
  value = module.vpc
}

output "cluster_name" {
  value = local.cluster_name
}

output "eks_cluster" {
  value = module.eks
}
