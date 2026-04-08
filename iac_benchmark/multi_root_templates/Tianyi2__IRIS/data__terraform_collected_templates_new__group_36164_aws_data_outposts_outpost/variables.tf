variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "id" {
  description = "Identifier of the Outpost."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the Outpost."
  type        = string
  default     = null
}

variable "arn" {
  description = "ARN."
  type        = string
  default     = null

  validation {
    condition     = var.arn == null || can(regex("^arn:aws:outposts:", var.arn))
    error_message = "data_aws_outposts_outpost, arn must be a valid AWS Outposts ARN starting with 'arn:aws:outposts:'."
  }
}

variable "owner_id" {
  description = "AWS Account identifier of the Outpost owner."
  type        = string
  default     = null

  validation {
    condition     = var.owner_id == null || can(regex("^[0-9]{12}$", var.owner_id))
    error_message = "data_aws_outposts_outpost, owner_id must be a valid 12-digit AWS Account ID."
  }
}