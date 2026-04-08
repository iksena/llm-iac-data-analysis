variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "A textual description for the workflow."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "steps" {
  description = "Specifies the details for the steps that are in the specified workflow."
  type = list(object({
    type = string
    copy_step_details = optional(object({
      name                 = optional(string)
      source_file_location = optional(string)
      overwrite_existing   = optional(string)
      destination_file_location = optional(object({
        efs_file_location = optional(object({
          file_system_id = optional(string)
          path           = optional(string)
        }))
        s3_file_location = optional(object({
          bucket = optional(string)
          key    = optional(string)
        }))
      }))
    }))
    custom_step_details = optional(object({
      name                 = optional(string)
      source_file_location = optional(string)
      target               = optional(string)
      timeout_seconds      = optional(number)
    }))
    decrypt_step_details = optional(object({
      name                 = optional(string)
      source_file_location = optional(string)
      overwrite_existing   = optional(string)
      type                 = string
      destination_file_location = optional(object({
        efs_file_location = optional(object({
          file_system_id = optional(string)
          path           = optional(string)
        }))
        s3_file_location = optional(object({
          bucket = optional(string)
          key    = optional(string)
        }))
      }))
    }))
    delete_step_details = optional(object({
      name                 = optional(string)
      source_file_location = optional(string)
    }))
    tag_step_details = optional(object({
      name                 = optional(string)
      source_file_location = optional(string)
      tags = optional(list(object({
        key   = string
        value = string
      })))
    }))
  }))

  validation {
    condition = alltrue([
      for step in var.steps : contains(["COPY", "CUSTOM", "DECRYPT", "DELETE", "TAG"], step.type)
    ])
    error_message = "resource_aws_transfer_workflow, steps - Step type must be one of: COPY, CUSTOM, DECRYPT, DELETE, or TAG."
  }

  validation {
    condition = alltrue([
      for step in var.steps :
      step.decrypt_step_details == null || step.decrypt_step_details.type == "PGP"
    ])
    error_message = "resource_aws_transfer_workflow, steps - Decrypt step type must be 'PGP'."
  }

  validation {
    condition = alltrue([
      for step in var.steps :
      step.copy_step_details == null || step.copy_step_details.overwrite_existing == null || contains(["TRUE", "FALSE"], step.copy_step_details.overwrite_existing)
    ])
    error_message = "resource_aws_transfer_workflow, steps - Copy step overwrite_existing must be 'TRUE' or 'FALSE'."
  }

  validation {
    condition = alltrue([
      for step in var.steps :
      step.decrypt_step_details == null || step.decrypt_step_details.overwrite_existing == null || contains(["TRUE", "FALSE"], step.decrypt_step_details.overwrite_existing)
    ])
    error_message = "resource_aws_transfer_workflow, steps - Decrypt step overwrite_existing must be 'TRUE' or 'FALSE'."
  }

  validation {
    condition = alltrue([
      for step in var.steps :
      step.tag_step_details == null || step.tag_step_details.tags == null || length(step.tag_step_details.tags) >= 1 && length(step.tag_step_details.tags) <= 10
    ])
    error_message = "resource_aws_transfer_workflow, steps - Tag step must contain from 1 to 10 key/value pairs."
  }
}

variable "on_exception_steps" {
  description = "Specifies the steps (actions) to take if errors are encountered during execution of the workflow."
  type = list(object({
    type = string
    copy_step_details = optional(object({
      name                 = optional(string)
      source_file_location = optional(string)
      overwrite_existing   = optional(string)
      destination_file_location = optional(object({
        efs_file_location = optional(object({
          file_system_id = optional(string)
          path           = optional(string)
        }))
        s3_file_location = optional(object({
          bucket = optional(string)
          key    = optional(string)
        }))
      }))
    }))
    custom_step_details = optional(object({
      name                 = optional(string)
      source_file_location = optional(string)
      target               = optional(string)
      timeout_seconds      = optional(number)
    }))
    decrypt_step_details = optional(object({
      name                 = optional(string)
      source_file_location = optional(string)
      overwrite_existing   = optional(string)
      type                 = string
      destination_file_location = optional(object({
        efs_file_location = optional(object({
          file_system_id = optional(string)
          path           = optional(string)
        }))
        s3_file_location = optional(object({
          bucket = optional(string)
          key    = optional(string)
        }))
      }))
    }))
    delete_step_details = optional(object({
      name                 = optional(string)
      source_file_location = optional(string)
    }))
    tag_step_details = optional(object({
      name                 = optional(string)
      source_file_location = optional(string)
      tags = optional(list(object({
        key   = string
        value = string
      })))
    }))
  }))
  default = null

  validation {
    condition = var.on_exception_steps == null || alltrue([
      for step in var.on_exception_steps : contains(["COPY", "CUSTOM", "DECRYPT", "DELETE", "TAG"], step.type)
    ])
    error_message = "resource_aws_transfer_workflow, on_exception_steps - Step type must be one of: COPY, CUSTOM, DECRYPT, DELETE, or TAG."
  }

  validation {
    condition = var.on_exception_steps == null || alltrue([
      for step in var.on_exception_steps :
      step.decrypt_step_details == null || step.decrypt_step_details.type == "PGP"
    ])
    error_message = "resource_aws_transfer_workflow, on_exception_steps - Decrypt step type must be 'PGP'."
  }

  validation {
    condition = var.on_exception_steps == null || alltrue([
      for step in var.on_exception_steps :
      step.copy_step_details == null || step.copy_step_details.overwrite_existing == null || contains(["TRUE", "FALSE"], step.copy_step_details.overwrite_existing)
    ])
    error_message = "resource_aws_transfer_workflow, on_exception_steps - Copy step overwrite_existing must be 'TRUE' or 'FALSE'."
  }

  validation {
    condition = var.on_exception_steps == null || alltrue([
      for step in var.on_exception_steps :
      step.decrypt_step_details == null || step.decrypt_step_details.overwrite_existing == null || contains(["TRUE", "FALSE"], step.decrypt_step_details.overwrite_existing)
    ])
    error_message = "resource_aws_transfer_workflow, on_exception_steps - Decrypt step overwrite_existing must be 'TRUE' or 'FALSE'."
  }

  validation {
    condition = var.on_exception_steps == null || alltrue([
      for step in var.on_exception_steps :
      step.tag_step_details == null || step.tag_step_details.tags == null || length(step.tag_step_details.tags) >= 1 && length(step.tag_step_details.tags) <= 10
    ])
    error_message = "resource_aws_transfer_workflow, on_exception_steps - Tag step must contain from 1 to 10 key/value pairs."
  }
}