###################
# AWS Config
###################
variable "aws_region" {
  default     = "us-east-1"
  description = "aws region where our resources going to create choose"
}

variable "aws_access_key" {
  type = string
  description = "aws_access_key"
  default = "unused"
}

variable "aws_secret_key" {
  type = string
  description = "aws_secret_key"
  default = "unused"
}

###################
# Project Config
###################

variable "project_name" {
  description = "Project Name"
  default     = "DemoA"
}

variable "key_name" {
  description = "EC2 SSH Key name"
  default     = "user1"
}

variable "app_port" {
  description = "App port"
  default     = 80
}

variable "callback_urls" {
  description = "The cognito client callback url"
  default     = "https://demoapp/callback"
}

variable "logout_urls" {
  description = "The cognito client logout url"
  default     = "https://demoapp/logout"
}

variable "domain_prefix" {
  description = "The cognito client domain(you can use your own domain)"
  default     = "tsztwozeroone"
}
