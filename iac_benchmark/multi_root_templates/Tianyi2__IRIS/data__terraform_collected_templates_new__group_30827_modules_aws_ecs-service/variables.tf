variable "service_name" {
  type = string
}

variable "cluster_id" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "task_definition_arn" {
  type = string
}

variable "desired_task_count" {
  type = number
  default = 1
}

variable "max_task_count" {
  type = number
  default = 1
}


variable "ordered_placement_strategy_type" {
  type = string
  default = "binpack"
}

variable "ordered_placement_strategy_field" {
  type = string
  default = "cpu"
}

variable "target_group_arn" {
  type = string
  default = null
}

variable "container_name" {
  type = string
  default = null
}

variable "container_port" {
  type = number
  default = null
}

variable "enable_autoscaling" {
  type = bool
  default = false
}

variable "target_average_cpu_utilizazion" {
  type = number
  default = 80
}

variable "target_average_memory_utilizazion" {
  type = number
  default = 80
}

variable "enable_service_discovery" {
  type = bool
  default = false
}

variable "service_dns_name" {
  type = string
  default = ""
}

variable "service_dns_description" {
  type = string
  default = ""
}

variable "vpc_id" {
  type = string
  default = null
}

variable "attach_loadbalancer" {
  type = map(object({
    target_group_arn = string,
    container_port =   number
  }))

  default = {}
}

variable "scheduling_strategy" {
  type = string
  default = "REPLICA"
}

variable "retention_in_days" {
  type = number
  default = 30
}