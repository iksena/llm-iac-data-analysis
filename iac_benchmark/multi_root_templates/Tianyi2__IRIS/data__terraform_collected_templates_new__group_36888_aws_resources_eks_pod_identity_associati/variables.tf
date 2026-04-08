variable "cluster_name" {
  description = "The name of the cluster to create the association in."
  type        = string

  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "resource_aws_eks_pod_identity_association, cluster_name must not be empty."
  }
}

variable "namespace" {
  description = "The name of the Kubernetes namespace inside the cluster to create the association in. The service account and the pods that use the service account must be in this namespace."
  type        = string

  validation {
    condition     = length(var.namespace) > 0
    error_message = "resource_aws_eks_pod_identity_association, namespace must not be empty."
  }
}

variable "role_arn" {
  description = "The Amazon Resource Name (ARN) of the IAM role to associate with the service account. The EKS Pod Identity agent manages credentials to assume this role for applications in the containers in the pods that use this service account."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/.+", var.role_arn))
    error_message = "resource_aws_eks_pod_identity_association, role_arn must be a valid IAM role ARN."
  }
}

variable "service_account" {
  description = "The name of the Kubernetes service account inside the cluster to associate the IAM credentials with."
  type        = string

  validation {
    condition     = length(var.service_account) > 0
    error_message = "resource_aws_eks_pod_identity_association, service_account must not be empty."
  }
}

variable "disable_session_tags" {
  description = "Disable the tags that are automatically added to role session by Amazon EKS."
  type        = bool
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "target_role_arn" {
  description = "The Amazon Resource Name (ARN) of the IAM role to be chained to the the IAM role specified as role_arn."
  type        = string
  default     = null

  validation {
    condition     = var.target_role_arn == null || can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/.+", var.target_role_arn))
    error_message = "resource_aws_eks_pod_identity_association, target_role_arn must be a valid IAM role ARN when provided."
  }
}