variable "cluster_name" {
  type = string
}

variable "instance_type" {
  type = string
  default = "t3.medium"
}

variable "key_name" {
  type = string
}


variable "min_size" {
  type = number
  default = 1
}

variable "max_size" {
  type = number
  default = 1
}

variable "subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "iam_instance_profile" {
  type = string
}

variable "tcp_ingress" {
  type = map(list(string))
  default = {}
}

variable "allow_additional_sg" {
  type = map(object({
    security_groups = list(string)
    from_port       = string
    to_port         = string
    protocol        = string
  }))
  default = {}
}

variable "placement_strategy" {
  type = string
  default = null
}

variable "force_delete" {
  type = bool
  default = true
}

variable "protect_from_scale_in" {
  type = bool
  default = false
}

variable "create_placement_strategy" {
  type = bool
  default = false
}


variable "loadbalancer_sg" {
  type = string
  default = null
}

variable "allow_cluster_lb" {
  type = bool
  default = false
}

variable "disk_size" {
  type = number
  default = 20
}