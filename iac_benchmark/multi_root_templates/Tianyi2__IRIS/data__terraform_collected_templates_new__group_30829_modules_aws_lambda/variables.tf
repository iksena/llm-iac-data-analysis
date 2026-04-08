variable "source_dir" {
  type = string
  description = "(Required) the directory where the lambda lives."
}

variable "output_path" {
  type = string
  description = "(Required) The name of the output zip and the path where it will be stored."
}

variable "bucket" {
  type = string
  description = "(Required) The S3 bucket where the zip will be deployed."
}

variable "bucket_key" {
  type = string
  description = "(Required) The S3 bucket key where the zip will be deployed."
}

variable "function_name" {
  type = string
  description = "(Required) The name of the lambda function."
}

variable "runtime" {
  type = string
  description = "(Required) The runtime environment of the lambda."
}

variable "handler" {
  type = string
  description = "(Required) The handler function that will be executed."
}

variable "timeout" {
  type = number
  description = "(Optional) Max time the lambda can run before stopped. Default is 3 seconds."
  default = 3
}

variable "memory_size" {
  type = number
  description = "(Optional) How much memory the lambda should have during the runtime. Default is 128mb."
  default = 128
}

variable "environment_variables" {
  type = list(map(string))
  description  = "(Optional) Environmente variables to add to the lambda."
  default = []
}

variable "create_policy" {
  type = bool
  description = "(Optional) Set to true if you want to associate a custom policy to the lambda. Default is false."
  default = false
}

variable "create_role" {
  type = bool
  description = "(Optional) Set to true if you want to create a custom role for the lambda. Default is false."
  default = false
}

variable "role_arn" {
  type = string
  description = "(optional) if create_role=false pass a IAM Role to associate to the lambda"
  default = null
}

variable "policy_name" {
  type = string
  description = "(Required) The policy name associated to the lambda."
  default =  ""
}

variable "policy_description" {
  type = string
  description = "(Optional) The policy description."
  default = ""
}

variable "policy" {
  type = string
  description = "(Optional) The custom policy associated to the lambda."
  default = ""
}

variable "layers" {
  type = list(string)
  description = "(Optional) Layers to add to the lambda."
  default = [ ]
}

variable "provider_alias" {
  type = string
  default = null
}

variable "retention_in_days" {
  type = number
  default = 30
}

variable "deploy_in_vpc" {
  type = bool
  description = "(optional) Set true if you need your VPC inside a VPC. Default is false"
  default = false
}

variable "subnet_ids" {
  type = list(string)
  default = []
}

variable "security_group_ids" {
  type = list(string)
  default = []
}

variable "vpc_id" {
  type = string
  description = ""
}