variable "aws_profile" {
  type                  = string
  default               = "default"
  description           = "Specify an aws profile name to use for access credentials"
}

variable "aws_env" {
  type                  = string
  default               = "dev"
  description           = "Specify a value for the Environment tag"
}

variable "aws_region" {
  type                  = string
  default               = "us-east-2"
  description           = "Specify the AWS region to be used for resource creations"
}

variable "app_name" {
  type                  = string
  description           = "Specify an application or project name, used primarily for tagging"
  default               = "benchmark-app"
}

variable "app_shortcode" {
  type                  = string
  description           = "Specify a short-code or pneumonic for this application or project"
  default               = "bmk"
}

## VPC ##

# use an RFC 1918 reserved IP range
variable "vpc_cidr" {
  type                  = string
  default               = "10.8.0.0/16"
  description           = "Specify CIDR range for VPC"
}

variable "vpc_name" {
  type                  = string
  default               = "packer_vpc"
  description           = "Specify a name for VPC for labeling purposes"
}

variable "priv_subnet_cidr" {
  type                  = string
  default               = "10.8.1.0/24"
  description           = "Specify a CIDR range for private subnet within VPC"
}

variable "priv_subnet_name" {
  type                  = string
  default               = "packer_subnet"
  description           = "Specify a name for private subnet for labeling purposes"
}

