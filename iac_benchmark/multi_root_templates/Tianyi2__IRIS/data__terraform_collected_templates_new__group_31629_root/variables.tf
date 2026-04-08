variable "location" {
  description = "Common resource group to target"
  type        = string
  default     = "centralus"
}

variable "instance" {
  type    = number
  default = 3
}

variable "prefix" {
  type    = string
  default = "demo"
}

variable "suffix" {
  type    = string
  default = "logging"
}

variable "client_secret" {
  type    = string
  default = "Invalid"
}

variable "client_id" {
  type    = string
  default = "Invalid"

}

variable "subscription_id" {
  type    = string
  default = "Invalid"

}

variable "tenant_id" {
  type    = string
  default = "Invalid"
}

variable "log_retention_days" {
  type    = number
  default = 30
}


