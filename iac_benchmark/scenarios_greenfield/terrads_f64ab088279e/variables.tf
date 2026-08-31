# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Copyright (c) Neferdata, Corp

variable "create_rds_instance" {
  description = "Flag to determine if the RDS instance should be created"
  type        = bool
  default     = false
}

variable "create_redis_cluster" {
  description = "Flag to determine if the Redis cluster should be created"
  type        = bool
  default     = false
}

variable "create_eks_cluster" {
  description = "Flag to determine if the EKS cluster should be created"
  type        = bool
  default     = false
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "db_username" {
  description = "The database username"
  type        = string
  default     = "benchmarkadmin"
}

variable "db_password" {
  description = "The database password"
  type        = string
  sensitive   = true   # This ensures Terraform won't display this value in its output.
  default     = "BenchmarkPassw0rd!"
}

variable "k8s_namespace" {
  description = "The Kubernetes namespace for the service account."
  default     = "default"
}
