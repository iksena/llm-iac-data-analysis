variable "enable_scale_out_on_cpu" {
  type = bool
  description = "(optional) enable scale out policy based on cpu"
  default = true
}

variable "cluster_name" {
  type        = string
  description = "the name of an ECS cluster"
}

variable "cluster_environment" {
  type        = string
  description = "the ECS cluster environment"
  default     = "prod"
}

variable "autoscaling_group_name" {
  type = string
}

variable "create_alarm_on_cpu_usage" {
  type = bool
  default = false
}

variable "cpu_threshold" {
  type = number
  description = "(optional) CPU threshold to set alarm. Default 50"
  default = 50
}

variable "cpu_actions_enabled" {
  type = bool
  description = "(optional) set true if you want to start autoscaling in case of alarm"
  default = false
}