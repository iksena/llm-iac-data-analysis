# variable "cluster_name" {
#   type = string
# }

variable "task_name" {
  type = string
}

variable "task_definition" {
  type = string
}

variable "network_mode" {
  type = string
  default = "bridge"
}

variable "task_role_arn" {
  type = string
  default = null
}

variable "execution_role_arn" {
  type = string
  default = null
}

variable "volume_mapping" {
  type = map(string)
  default = {}
}