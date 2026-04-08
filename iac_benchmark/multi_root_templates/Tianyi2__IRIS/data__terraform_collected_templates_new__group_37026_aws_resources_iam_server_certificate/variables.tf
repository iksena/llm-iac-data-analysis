variable "certificate_body" {
  description = "The contents of the public key certificate in PEM-encoded format"
  type        = string

  validation {
    condition     = can(regex("-----BEGIN CERTIFICATE-----", var.certificate_body))
    error_message = "resource_aws_iam_server_certificate, certificate_body must be a valid PEM-encoded certificate starting with '-----BEGIN CERTIFICATE-----'."
  }
}

variable "certificate_chain" {
  description = "The contents of the certificate chain. This is typically a concatenation of the PEM-encoded public key certificates of the chain"
  type        = string
  default     = null

  validation {
    condition     = var.certificate_chain == null || can(regex("-----BEGIN CERTIFICATE-----", var.certificate_chain))
    error_message = "resource_aws_iam_server_certificate, certificate_chain must be null or a valid PEM-encoded certificate chain starting with '-----BEGIN CERTIFICATE-----'."
  }
}

variable "name" {
  description = "The name of the Server Certificate. Do not include the path in this value. If omitted, Terraform will assign a random, unique name"
  type        = string
  default     = null

  validation {
    condition     = var.name == null || can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.name))
    error_message = "resource_aws_iam_server_certificate, name must contain only alphanumeric characters and the following: +=,.@_-"
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name"
  type        = string
  default     = null

  validation {
    condition     = var.name_prefix == null || can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.name_prefix))
    error_message = "resource_aws_iam_server_certificate, name_prefix must contain only alphanumeric characters and the following: +=,.@_-"
  }
}

variable "path" {
  description = "The IAM path for the server certificate. If it is not included, it defaults to a slash (/). If this certificate is for use with AWS CloudFront, the path must be in format /cloudfront/your_path_here"
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/", var.path)) && can(regex("/$", var.path))
    error_message = "resource_aws_iam_server_certificate, path must start and end with a forward slash (/)."
  }
}

variable "private_key" {
  description = "The contents of the private key in PEM-encoded format"
  type        = string
  sensitive   = true

  validation {
    condition     = can(regex("-----BEGIN.*PRIVATE KEY-----", var.private_key))
    error_message = "resource_aws_iam_server_certificate, private_key must be a valid PEM-encoded private key."
  }
}

variable "tags" {
  description = "Map of resource tags for the server certificate"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{1,128}$", k))
    ])
    error_message = "resource_aws_iam_server_certificate, tags keys must be between 1 and 128 characters."
  }

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{0,256}$", v))
    ])
    error_message = "resource_aws_iam_server_certificate, tags values must be between 0 and 256 characters."
  }
}

variable "timeouts" {
  description = "Configuration options for operation timeouts"
  type = object({
    delete = optional(string)
  })
  default = null

  validation {
    condition     = var.timeouts == null || var.timeouts.delete == null || can(regex("^[0-9]+(s|m|h)$", var.timeouts.delete))
    error_message = "resource_aws_iam_server_certificate, timeouts.delete must be a valid duration format (e.g., '15m', '30s', '1h')."
  }
}