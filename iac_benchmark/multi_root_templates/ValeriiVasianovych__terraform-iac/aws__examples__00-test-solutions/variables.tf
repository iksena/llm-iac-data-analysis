# Variables
variable "region" {
  type        = string
  description = "The region in which to launch the EC2 instance"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "The environment in which to launch the EC2 instance"
  # default     = "dev"
}

variable "instance_types" {
  type        = map(string)
  description = "The types of instances to launch"
  default = {
    dev     = "t2.micro"
    staging = "t2.medium"
    prod    = "t2.large"
  }
}

locals {
  file_content = file("${path.module}/hello-tf.txt")
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags to apply to all resources"
  default = {
    Owner    = "Valerii Vasianovych"
    Provider = "AWS-Terraform"
  }
}

# variable "1_helloworld" { # incorrect variable name
#   type        = string
#   default     = "Hello World"
# }

# variable "hello_world_2" { # correct variable name
#   type        = string
#   default     = "Hello World"
# }