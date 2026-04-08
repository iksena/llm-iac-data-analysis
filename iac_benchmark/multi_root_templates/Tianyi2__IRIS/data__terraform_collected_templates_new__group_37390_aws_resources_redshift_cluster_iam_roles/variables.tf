variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cluster_identifier" {
  description = "The name of the Redshift Cluster IAM Roles."
  type        = string

  validation {
    condition     = var.cluster_identifier != null && var.cluster_identifier != ""
    error_message = "resource_aws_redshift_cluster_iam_roles, cluster_identifier must be a non-empty string."
  }
}

variable "iam_role_arns" {
  description = "A list of IAM Role ARNs to associate with the cluster. A Maximum of 10 can be associated to the cluster at any time."
  type        = list(string)
  default     = null

  validation {
    condition = var.iam_role_arns == null || (
      length(var.iam_role_arns) <= 10 &&
      alltrue([
        for arn in var.iam_role_arns : can(regex("^arn:aws:iam::", arn))
      ])
    )
    error_message = "resource_aws_redshift_cluster_iam_roles, iam_role_arns must be a list of valid IAM role ARNs with a maximum of 10 entries."
  }
}

variable "default_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) for the IAM role that was set as default for the cluster when the cluster was created."
  type        = string
  default     = null

  validation {
    condition     = var.default_iam_role_arn == null || can(regex("^arn:aws:iam::", var.default_iam_role_arn))
    error_message = "resource_aws_redshift_cluster_iam_roles, default_iam_role_arn must be a valid IAM role ARN."
  }
}