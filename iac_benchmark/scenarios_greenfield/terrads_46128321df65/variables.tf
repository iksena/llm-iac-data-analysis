variable "environment" {
  type        = string
  default     = "dev"
  description = "The environment to deploy the resources"
}

locals {
  global_tags = {
    Environment = var.environment
    Department  = "devops"
    Owner       = "arryw"
  }
}