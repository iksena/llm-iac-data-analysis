variable "ecr_repository_name" {
  description = "Name for the ECR repository"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
  default     = {}
}

locals {
  tags_all = merge(var.tags, {
    Module = "aws-ecr-repository"
  })
}

variable "force_delete" {
  description = "Allow the ECR repository to be deleted even if it contains images"
  type        = bool
  default     = false
}
