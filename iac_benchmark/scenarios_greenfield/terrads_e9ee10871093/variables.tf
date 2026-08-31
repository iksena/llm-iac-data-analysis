variable "application_name" {
  description = "Application Service Name"
  type        = string
  default     = "web_backend"
}

variable "application_port" {
  description = "Application Port"
  type        = number
  default     = 80
}

variable "application_health_check_path" {
  description = "Application Health Check Path"
  type        = string
  default     = "/"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-1"

}

variable "aws_availability_zones" {
  description = "AWS Availability Zones"
  type        = list(string)
  default     = ["us-west-1a", "us-west-1c"]
}

variable "github_account" {
  description = "GitHub Account to setup IAM role for GitHub Actions"
  type        = string
  default     = "benchmark-org"
}
