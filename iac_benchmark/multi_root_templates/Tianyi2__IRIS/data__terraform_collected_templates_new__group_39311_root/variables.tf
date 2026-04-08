/*
 * Copyright (C) 2019 Risk Focus, Inc. - All Rights Reserved
 * You may use, distribute and modify this code under the
 * terms of the Apache License Version 2.0.
 * http://www.apache.org/licenses
 */

variable "project_prefix" {
  type = string
}

variable "project_fqdn" {
  type = string
}

variable "project_rev_fqdn" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  default = "172.31.0.0/16"
}

variable "ip_whitelist" {
  type    = list(string)
  default = []
}

variable "config_output_path" {
}

variable "bastion_ssh_keys" {
  type = list(string)
}

variable "kubectl_assume_role" {
  default = ""
}

variable "spot_price" {
  default = ""
}

variable "key_name" {
  type = string
}

variable "bastion_instance_size" {
  type    = string
  default = "t3.nano"
}

variable "eks_authorized_roles" {
  type    = list(string)
  default = []
}

variable "instance_types" {
  type = list(string)
}

variable "worker_groups" {
  type = any
  default = [
    {
      instance_type = "t3.large"
    },
    {
      instance_type = "t3.2xlarge"
    }
  ]
}

variable "extra_policy_arn" {
  type    = string
  default = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
