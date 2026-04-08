variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "agent_arns" {
  description = "A list of DataSync Agent ARNs with which this location will be associated. For agentless cross-cloud transfers, this parameter does not need to be specified."
  type        = list(string)
  default     = null

  validation {
    condition     = var.agent_arns == null || length(var.agent_arns) > 0
    error_message = "resource_aws_datasync_location_object_storage, agent_arns must contain at least one ARN if provided."
  }
}

variable "access_key" {
  description = "The access key is used if credentials are required to access the self-managed object storage server. If your object storage requires a user name and password to authenticate, use access_key and secret_key to provide the user name and password, respectively."
  type        = string
  default     = null
  sensitive   = true
}

variable "bucket_name" {
  description = "The bucket on the self-managed object storage server that is used to read data from."
  type        = string

  validation {
    condition     = length(var.bucket_name) > 0
    error_message = "resource_aws_datasync_location_object_storage, bucket_name cannot be empty."
  }
}

variable "secret_key" {
  description = "The secret key is used if credentials are required to access the self-managed object storage server. If your object storage requires a user name and password to authenticate, use access_key and secret_key to provide the user name and password, respectively."
  type        = string
  default     = null
  sensitive   = true
}

variable "server_certificate" {
  description = "Specifies a certificate to authenticate with an object storage system that uses a private or self-signed certificate authority (CA). You must specify a Base64-encoded .pem string. The certificate can be up to 32768 bytes (before Base64 encoding)."
  type        = string
  default     = null

  validation {
    condition     = var.server_certificate == null || length(var.server_certificate) <= 32768
    error_message = "resource_aws_datasync_location_object_storage, server_certificate can be up to 32768 bytes (before Base64 encoding)."
  }
}

variable "server_hostname" {
  description = "The name of the self-managed object storage server. This value is the IP address or Domain Name Service (DNS) name of the object storage server. An agent uses this host name to mount the object storage server in a network."
  type        = string

  validation {
    condition     = length(var.server_hostname) > 0
    error_message = "resource_aws_datasync_location_object_storage, server_hostname cannot be empty."
  }
}

variable "server_protocol" {
  description = "The protocol that the object storage server uses to communicate. Valid values are HTTP or HTTPS."
  type        = string
  default     = null

  validation {
    condition     = var.server_protocol == null || contains(["HTTP", "HTTPS"], var.server_protocol)
    error_message = "resource_aws_datasync_location_object_storage, server_protocol must be either 'HTTP' or 'HTTPS'."
  }
}

variable "server_port" {
  description = "The port that your self-managed object storage server accepts inbound network traffic on. The server port is set by default to TCP 80 (HTTP) or TCP 443 (HTTPS). You can specify a custom port if your self-managed object storage server requires one."
  type        = number
  default     = null

  validation {
    condition     = var.server_port == null || (var.server_port >= 1 && var.server_port <= 65535)
    error_message = "resource_aws_datasync_location_object_storage, server_port must be between 1 and 65535."
  }
}

variable "subdirectory" {
  description = "A subdirectory in the HDFS cluster. This subdirectory is used to read data from or write data to the HDFS cluster. If the subdirectory isn't specified, it will default to /."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value pairs of resource tags to assign to the DataSync Location. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}