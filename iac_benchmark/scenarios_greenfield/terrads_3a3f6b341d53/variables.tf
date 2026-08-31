variable "deploy_role_arn" {
  type        = string
  description = "Provided by Jenkins CI/CD"
  default     = "unused"
}

variable "project_prefix" {
  type        = string
  description = "Project Prefix"
  default     = "benchmark"
}

variable "env" {
  type        = string
  description = "Environment"
  default     = "dev"
}

variable "vpc_config" {
  type = object({
    cidr               = string
    network_acls_ports = map(list(string))
    subnets = map(list(object({
      az   = string
      cidr = string
    })))
  })
  description = "VPC Configuration"
  default = {
    cidr = "10.0.0.0/16"
    network_acls_ports = {
      ingress = ["80", "443"]
      egress  = ["0"]
    }
    subnets = {
      public       = [{ az = "us-east-1a", cidr = "10.0.0.0/24" }, { az = "us-east-1b", cidr = "10.0.1.0/24" }]
      outerprivate = [{ az = "us-east-1a", cidr = "10.0.2.0/24" }, { az = "us-east-1b", cidr = "10.0.3.0/24" }]
      innerprivate = [{ az = "us-east-1a", cidr = "10.0.4.0/24" }, { az = "us-east-1b", cidr = "10.0.5.0/24" }]
    }
  }
}
