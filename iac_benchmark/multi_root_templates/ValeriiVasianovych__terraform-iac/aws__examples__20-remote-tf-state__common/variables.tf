variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cidr_block" {
    description = "CIDR block for the VPC in Dev1"
    type        = string
    default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
    description = "CIDR block for the public subnet in Dev1"
    type        = list(string)
    default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "common_tags" {
    description = "Common tags for all resources"
    type        = map(string)
    default     = {
        "Project" = "Remote TF States"
        "Owner" = "Valerii Vasianovych"
    }
}

variable "env" {
    description = "Environment name"
    type        = string
    default     = "dev"
}


variable "developer" {
    description = "Developer name"
    type        = list(string)
    default     = ["Dev1: Alise", "Dev2: Valerii", "Dev3: Weronika"]
}

variable "ingress_ports" {
  description = "Ingress ports based on environment"
  type = map(list(number))
  default = {
    dev     = [80, 22]
    prod    = [80, 443, 3306, 22]
    staging = [443, 3306]
  }
}

variable "instance_type" {
    description = "Instance type"
    type        = map(string)
    default = {
        "dev"     = "t2.micro"
        "prod"    = "t3.medium"
    }
}