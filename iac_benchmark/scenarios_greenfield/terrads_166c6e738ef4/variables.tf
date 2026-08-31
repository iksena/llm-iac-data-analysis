variable "AWS_ENV" {
  type        = string
  default     = "dev"
}

variable "AWS_REGION" {
  type        = string
  default     = "us-east-1"
}

variable "VPC_CIDR" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "PUBLIC_CIDR" {
  type = string 
  default     = "10.0.0.0/24"
}

variable "PRIVATE_CIDR" {
  type = string 
  default     = "10.0.1.0/24"
}