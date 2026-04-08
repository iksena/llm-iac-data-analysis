variable "custom_key_store_name" {
  description = "Unique name for Custom Key Store"
  type        = string

  validation {
    condition     = length(var.custom_key_store_name) > 0
    error_message = "resource_aws_kms_custom_key_store, custom_key_store_name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "custom_key_store_type" {
  description = "Specifies the type of key store to create. Valid values are AWS_CLOUDHSM and EXTERNAL_KEY_STORE. If omitted, AWS will default the value to AWS_CLOUDHSM"
  type        = string
  default     = null

  validation {
    condition     = var.custom_key_store_type == null || contains(["AWS_CLOUDHSM", "EXTERNAL_KEY_STORE"], var.custom_key_store_type)
    error_message = "resource_aws_kms_custom_key_store, custom_key_store_type must be either 'AWS_CLOUDHSM' or 'EXTERNAL_KEY_STORE'."
  }
}

variable "cloud_hsm_cluster_id" {
  description = "Cluster ID of CloudHSM. Required when custom_key_store_type is AWS_CLOUDHSM"
  type        = string
  default     = null
}

variable "key_store_password" {
  description = "Specifies the kmsuser password for an AWS CloudHSM key store. Required when custom_key_store_type is AWS_CLOUDHSM"
  type        = string
  default     = null
  sensitive   = true
}

variable "trust_anchor_certificate" {
  description = "Specifies the certificate for an AWS CloudHSM key store. Required when custom_key_store_type is AWS_CLOUDHSM"
  type        = string
  default     = null
}

variable "xks_proxy_authentication_credential" {
  description = "Specifies an authentication credential for the external key store proxy (XKS proxy). Required when custom_key_store_type is EXTERNAL_KEY_STORE"
  type = object({
    access_key_id         = string
    raw_secret_access_key = string
  })
  default   = null
  sensitive = true

  validation {
    condition = var.xks_proxy_authentication_credential == null || (
      length(var.xks_proxy_authentication_credential.access_key_id) > 0 &&
      length(var.xks_proxy_authentication_credential.raw_secret_access_key) >= 43 &&
      length(var.xks_proxy_authentication_credential.raw_secret_access_key) <= 64
    )
    error_message = "resource_aws_kms_custom_key_store, xks_proxy_authentication_credential access_key_id must not be empty and raw_secret_access_key must be 43-64 characters."
  }
}

variable "xks_proxy_connectivity" {
  description = "Indicates how AWS KMS communicates with the external key store proxy. Required when custom_key_store_type is EXTERNAL_KEY_STORE"
  type        = string
  default     = null

  validation {
    condition     = var.xks_proxy_connectivity == null || contains(["VPC_ENDPOINT_SERVICE", "PUBLIC_ENDPOINT"], var.xks_proxy_connectivity)
    error_message = "resource_aws_kms_custom_key_store, xks_proxy_connectivity must be either 'VPC_ENDPOINT_SERVICE' or 'PUBLIC_ENDPOINT'."
  }
}

variable "xks_proxy_uri_endpoint" {
  description = "Specifies the endpoint that AWS KMS uses to send requests to the external key store proxy (XKS proxy). Required when custom_key_store_type is EXTERNAL_KEY_STORE"
  type        = string
  default     = null

  validation {
    condition     = var.xks_proxy_uri_endpoint == null || can(regex("^https://", var.xks_proxy_uri_endpoint))
    error_message = "resource_aws_kms_custom_key_store, xks_proxy_uri_endpoint must be a valid HTTPS URL."
  }
}

variable "xks_proxy_uri_path" {
  description = "Specifies the base path to the proxy APIs for this external key store. Required when custom_key_store_type is EXTERNAL_KEY_STORE"
  type        = string
  default     = null

  validation {
    condition     = var.xks_proxy_uri_path == null || can(regex("^/", var.xks_proxy_uri_path))
    error_message = "resource_aws_kms_custom_key_store, xks_proxy_uri_path must start with a forward slash."
  }
}

variable "xks_proxy_vpc_endpoint_service_name" {
  description = "Specifies the name of the Amazon VPC endpoint service for interface endpoints that is used to communicate with your external key store proxy (XKS proxy). Required when xks_proxy_connectivity is VPC_ENDPOINT_SERVICE"
  type        = string
  default     = null
}

variable "timeouts_create" {
  description = "Timeout for creating the KMS custom key store"
  type        = string
  default     = "15m"
}

variable "timeouts_update" {
  description = "Timeout for updating the KMS custom key store"
  type        = string
  default     = "15m"
}

variable "timeouts_delete" {
  description = "Timeout for deleting the KMS custom key store"
  type        = string
  default     = "15m"
}