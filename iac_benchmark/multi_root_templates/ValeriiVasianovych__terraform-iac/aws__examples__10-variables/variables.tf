variable "region" {
  description = "The AWS region to launch the instance"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "The type of instance to launch"
  type        = string
  default     = "t2.micro"
}

variable "allow_sg_ports" {
  description = "The ports to open on the security group"
  type        = list(number)
  default     = [22, 80, 443]
}

variable "monitoring_value" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = false
}

variable "common_tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Owner       = "Valerii Vasianovych"
    Project     = "AWS Instance Creation"
    Environment = "Development"
  }
}