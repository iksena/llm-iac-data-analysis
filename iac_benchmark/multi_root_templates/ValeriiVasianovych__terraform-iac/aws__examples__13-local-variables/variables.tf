variable "region" {
  description = "Default region"
  type        = string
  default     = "eu-central-1"  
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "local-variables example"  
}

variable "env" {
  description = "Environment"
  type        = string
  default     = "Development"  
}

variable "city" {
  description = "City Location"
  type        = string
  default     = "New York"  
}

variable "country" {
  description = "Country location"
  type        = string
  default     = "United States"  
}
