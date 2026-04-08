variable "read_roles" {
  type        = list(string)
  description = "List of IAM Role ARNs allowed ReadOnly/Decrypt permissions"
  default     = null
}

variable "read_services" {
  type        = list(string)
  description = "List of AWS Services allowed ReadOnly/Decrypt permissions"
  default     = []
}

variable "read_service_conditions" {
  type = list(object({
    test     = string,
    variable = string,
    values   = list(string)
  }))
  default = []
}

variable "write_roles" {
  type        = list(string)
  description = "List of IAM Role ARNs allowed Encrypt/Decrypt permissions"
  default     = null
}

variable "write_services" {
  type        = list(string)
  description = "List of AWS Services allowed Encrypt/Decrypt permissions"
  default     = []
}

variable "write_service_conditions" {
  type = list(object({
    test     = string,
    variable = string,
    values   = list(string)
  }))
  default = []
}

variable "admin_roles" {
  type        = list(string)
  description = "List of IAM Role ARNs allowed KMS admin permissions"
  default     = null
}