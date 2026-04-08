# Infrastructure Configuration
variable "region" {
  description = "The AWS region"
  type        = string
  default     = ""
}

variable "env" {
  description = "The environment"
  type        = string
  default     = ""
}

# Network Configuration
variable "hosted_zone_name" {
  description = "The name of the hosted zone"
  type        = string
  default     = ""
}

# Instance Configuration
variable "instance_types" {
  description = "Map of instance types for different components"
  type        = map(string)
  default = {
    # Bastion host instance type - Used as a secure jump server to access private resources
    # bastion         = ""
    public_instance = ""
    private_instance = ""
    db_instance     = ""
  }
}

variable "key_name" {
  description = "The name of the key pair to be used for SSH access"
  type        = string
  default     = ""
}

# VPN Configuration
variable "vpn_server_cert_arn" {
  description = "The name of the server certificate"
  type        = string
  default     = ""
}

variable "vpn_client_cert_arn" {
  description = "The name of the client certificate"
  type        = string
  default     = ""
}

