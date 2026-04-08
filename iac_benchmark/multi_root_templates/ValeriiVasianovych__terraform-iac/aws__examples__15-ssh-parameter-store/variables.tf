variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "Valerii Vasianovych"
}

variable "common_tags" {
    description = "Common tags to apply to all resources"
    type        = map(string)
    default = {
        Project     = "SSM Parameter Store"
        Environment = "Development"
    }
}