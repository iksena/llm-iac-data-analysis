variable "name" {
  description = "Name for the Entity Recognizer. Has a maximum length of 63 characters. Can contain upper- and lower-case letters, numbers, and hypen (-)."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,63}$", var.name))
    error_message = "resource_aws_comprehend_entity_recognizer, name must be 1-63 characters long and can only contain letters, numbers, and hyphens."
  }
}

variable "data_access_role_arn" {
  description = "The ARN for an IAM Role which allows Comprehend to read the training and testing data."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.data_access_role_arn))
    error_message = "resource_aws_comprehend_entity_recognizer, data_access_role_arn must be a valid IAM role ARN."
  }
}

variable "language_code" {
  description = "Two-letter language code for the language. One of en, es, fr, it, de, or pt."
  type        = string

  validation {
    condition     = contains(["en", "es", "fr", "it", "de", "pt"], var.language_code)
    error_message = "resource_aws_comprehend_entity_recognizer, language_code must be one of: en, es, fr, it, de, pt."
  }
}

variable "input_data_config" {
  description = "Configuration for the training and testing data."
  type = object({
    data_format = optional(string, "COMPREHEND_CSV")
    entity_types = list(object({
      type = string
    }))
    annotations = optional(object({
      s3_uri     = string
      test_s3uri = optional(string)
    }))
    augmented_manifests = optional(list(object({
      annotation_data_s3_uri  = optional(string)
      attribute_names         = list(string)
      document_type           = optional(string, "PLAIN_TEXT_DOCUMENT")
      s3_uri                  = string
      source_documents_s3_uri = optional(string)
      split                   = optional(string, "TRAIN")
    })))
    documents = optional(object({
      input_format = optional(string, "ONE_DOC_PER_LINE")
      s3_uri       = string
      test_s3uri   = optional(string)
    }))
    entity_list = optional(object({
      s3_uri = string
    }))
  })

  validation {
    condition     = contains(["COMPREHEND_CSV", "AUGMENTED_MANIFEST"], var.input_data_config.data_format)
    error_message = "resource_aws_comprehend_entity_recognizer, input_data_config.data_format must be one of: COMPREHEND_CSV, AUGMENTED_MANIFEST."
  }

  validation {
    condition     = length(var.input_data_config.entity_types) <= 25 && length(var.input_data_config.entity_types) > 0
    error_message = "resource_aws_comprehend_entity_recognizer, input_data_config.entity_types must have at least 1 and at most 25 items."
  }

  validation {
    condition = alltrue([
      for et in var.input_data_config.entity_types :
      !can(regex("[\\n\\r\\t]", et.type))
    ])
    error_message = "resource_aws_comprehend_entity_recognizer, input_data_config.entity_types.type cannot contain newline, carriage return, or tab characters."
  }

  validation {
    condition     = var.input_data_config.annotations != null || var.input_data_config.entity_list != null
    error_message = "resource_aws_comprehend_entity_recognizer, input_data_config must have either annotations or entity_list specified."
  }

  validation {
    condition = var.input_data_config.augmented_manifests != null ? alltrue([
      for am in var.input_data_config.augmented_manifests :
      contains(["PLAIN_TEXT_DOCUMENT", "SEMI_STRUCTURED_DOCUMENT"], am.document_type)
    ]) : true
    error_message = "resource_aws_comprehend_entity_recognizer, input_data_config.augmented_manifests.document_type must be one of: PLAIN_TEXT_DOCUMENT, SEMI_STRUCTURED_DOCUMENT."
  }

  validation {
    condition = var.input_data_config.augmented_manifests != null ? alltrue([
      for am in var.input_data_config.augmented_manifests :
      contains(["TRAIN", "TEST"], am.split)
    ]) : true
    error_message = "resource_aws_comprehend_entity_recognizer, input_data_config.augmented_manifests.split must be one of: TRAIN, TEST."
  }

  validation {
    condition     = var.input_data_config.documents != null ? contains(["ONE_DOC_PER_LINE", "ONE_DOC_PER_FILE"], var.input_data_config.documents.input_format) : true
    error_message = "resource_aws_comprehend_entity_recognizer, input_data_config.documents.input_format must be one of: ONE_DOC_PER_LINE, ONE_DOC_PER_FILE."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "model_kms_key_id" {
  description = "The ID or ARN of a KMS Key used to encrypt trained Entity Recognizers."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "version_name" {
  description = "Name for the version of the Entity Recognizer. Each version must have a unique name within the Entity Recognizer. Has a maximum length of 63 characters. Can contain upper- and lower-case letters, numbers, and hypen (-). Conflicts with version_name_prefix."
  type        = string
  default     = null

  validation {
    condition     = var.version_name == null || can(regex("^[a-zA-Z0-9-]{1,63}$", var.version_name))
    error_message = "resource_aws_comprehend_entity_recognizer, version_name must be 1-63 characters long and can only contain letters, numbers, and hyphens."
  }
}

variable "version_name_prefix" {
  description = "Creates a unique version name beginning with the specified prefix. Has a maximum length of 37 characters. Can contain upper- and lower-case letters, numbers, and hypen (-). Conflicts with version_name."
  type        = string
  default     = null

  validation {
    condition     = var.version_name_prefix == null || can(regex("^[a-zA-Z0-9-]{1,37}$", var.version_name_prefix))
    error_message = "resource_aws_comprehend_entity_recognizer, version_name_prefix must be 1-37 characters long and can only contain letters, numbers, and hyphens."
  }
}

variable "volume_kms_key_id" {
  description = "ID or ARN of a KMS Key used to encrypt storage volumes during job processing."
  type        = string
  default     = null
}

variable "vpc_config" {
  description = "Configuration parameters for VPC to contain Entity Recognizer resources."
  type = object({
    security_group_ids = list(string)
    subnets            = list(string)
  })
  default = null

  validation {
    condition = var.vpc_config != null ? (
      length(var.vpc_config.security_group_ids) > 0 &&
      length(var.vpc_config.subnets) > 0
    ) : true
    error_message = "resource_aws_comprehend_entity_recognizer, vpc_config.security_group_ids and vpc_config.subnets must not be empty when vpc_config is specified."
  }
}

variable "timeouts" {
  description = "Timeout configuration for the resource operations."
  type = object({
    create = optional(string, "60m")
    update = optional(string, "60m")
    delete = optional(string, "30m")
  })
  default = {
    create = "60m"
    update = "60m"
    delete = "30m"
  }
}