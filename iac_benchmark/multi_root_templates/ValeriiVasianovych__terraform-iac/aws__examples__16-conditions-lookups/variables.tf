variable "region" {
  description = "Region variable"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Environment variable"
  type        = string
}

variable "sg_ports" {
  description = "Allow security group ports"
  type        = list(number)
  default     = [80, 443, 22]
}

variable "monitoring_value" {
  description = "Enable monitoring"
  type        = bool
  default     = false
}

# Lookup
variable "instance_size" {
  default = {
    "dev"     = "t2.micro"
    "prod"    = "t3.medium"
    "staging" = "t2.large"
  }
}

variable "sg_lookup_ports" {
  default = {
    "dev"  = [80, 443]
    "prod" = [80, 443, 22]
  }
}