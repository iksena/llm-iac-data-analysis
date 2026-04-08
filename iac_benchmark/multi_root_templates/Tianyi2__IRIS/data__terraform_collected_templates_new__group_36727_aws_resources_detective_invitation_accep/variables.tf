variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "graph_arn" {
  description = "ARN of the behavior graph that the member account is accepting the invitation for."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:detective:[a-z0-9-]+:[0-9]{12}:graph:[a-zA-Z0-9]+$", var.graph_arn))
    error_message = "resource_aws_detective_invitation_accepter, graph_arn must be a valid Detective graph ARN format."
  }
}