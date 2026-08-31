# Variables for AWS Resume Website

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "domain_name" {
  description = "Domain name for the website (e.g., yourname.com)"
  type        = string
  default     = "benchmark.example.com"
}

variable "api_subdomain" {
  description = "Subdomain for API (e.g., api)"
  type        = string
  default     = "api"
}

variable "jwt_secret" {
  description = "Secret key for JWT token signing"
  type        = string
  sensitive   = true
  default     = "benchmark-dummy-jwt-signing-secret-0000000000000000"
}

variable "admin_email" {
  description = "Admin email for initial setup"
  type        = string
  default     = "admin@example.com"
}

variable "admin_password" {
  description = "Admin password for initial setup"
  type        = string
  sensitive   = true
  default     = "Benchmark-Dummy-Passw0rd!"
}

variable "container_cpu" {
  description = "CPU units for the container (256, 512, 1024, etc.)"
  type        = number
  default     = 256
}

variable "container_memory" {
  description = "Memory for the container in MB"
  type        = number
  default     = 512
}

variable "min_capacity" {
  description = "Minimum number of tasks"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of tasks"
  type        = number
  default     = 3
}

variable "enable_spot_instances" {
  description = "Use Fargate Spot for cost savings"
  type        = bool
  default     = true
}

variable "db_min_capacity" {
  description = "Minimum Aurora capacity units"
  type        = number
  default     = 0.5
}

variable "db_max_capacity" {
  description = "Maximum Aurora capacity units"
  type        = number
  default     = 1
}