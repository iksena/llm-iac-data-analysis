variable "image_name" {
  description = "The name of the image. Must be unique to your account."
  type        = string

  validation {
    condition     = length(var.image_name) > 0
    error_message = "resource_aws_sagemaker_image, image_name must not be empty."
  }
}

variable "role_arn" {
  description = "The Amazon Resource Name (ARN) of an IAM role that enables Amazon SageMaker AI to perform tasks on your behalf."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::\\d{12}:role/.+", var.role_arn))
    error_message = "resource_aws_sagemaker_image, role_arn must be a valid IAM role ARN."
  }
}

variable "display_name" {
  description = "The display name of the image. When the image is added to a domain (must be unique to the domain)."
  type        = string
  default     = null
}

variable "description" {
  description = "The description of the image."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}