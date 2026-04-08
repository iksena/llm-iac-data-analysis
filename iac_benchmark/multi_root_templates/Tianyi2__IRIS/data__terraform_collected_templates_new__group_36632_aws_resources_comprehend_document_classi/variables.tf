variable "name" {
  description = "Name for the Document Classifier"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,63}$", var.name))
    error_message = "resource_aws_comprehend_document_classifier, name must be a maximum of 63 characters and can contain upper- and lower-case letters, numbers, and hypen (-)."
  }
}

variable "data_access_role_arn" {
  description = "The ARN for an IAM Role which allows Comprehend to read the training and testing data"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::", var.data_access_role_arn))
    error_message = "resource_aws_comprehend_document_classifier, data_access_role_arn must be a valid IAM role ARN."
  }
}

variable "language_code" {
  description = "Two-letter language code for the language"
  type        = string

  validation {
    condition     = contains(["en", "es", "fr", "it", "de", "pt"], var.language_code)
    error_message = "resource_aws_comprehend_document_classifier, language_code must be one of: en, es, fr, it, de, or pt."
  }
}

variable "input_data_config" {
  description = "Configuration for the training and testing data"
  type = object({
    data_format     = optional(string, "COMPREHEND_CSV")
    label_delimiter = optional(string, "|")
    s3_uri          = optional(string)
    test_s3uri      = optional(string)
    augmented_manifests = optional(list(object({
      annotation_data_s3_uri  = optional(string)
      attribute_names         = list(string)
      document_type           = optional(string, "PLAIN_TEXT_DOCUMENT")
      s3_uri                  = string
      source_documents_s3_uri = optional(string)
      split                   = optional(string, "TRAIN")
    })))
  })

  validation {
    condition     = var.input_data_config.data_format == null || contains(["COMPREHEND_CSV", "AUGMENTED_MANIFEST"], var.input_data_config.data_format)
    error_message = "resource_aws_comprehend_document_classifier, input_data_config.data_format must be one of: COMPREHEND_CSV or AUGMENTED_MANIFEST."
  }

  validation {
    condition     = var.input_data_config.label_delimiter == null || contains(["|", "~", "!", "@", "#", "$", "%", "^", "*", "-", "_", "+", "=", "\\", ":", ";", ">", "?", "/", " ", "\t"], var.input_data_config.label_delimiter)
    error_message = "resource_aws_comprehend_document_classifier, input_data_config.label_delimiter must be one of: |, ~, !, @, #, $, %, ^, *, -, _, +, =, \\, :, ;, >, ?, /, <space>, or <tab>."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "mode" {
  description = "The document classification mode"
  type        = string
  default     = "MULTI_CLASS"

  validation {
    condition     = contains(["MULTI_CLASS", "MULTI_LABEL"], var.mode)
    error_message = "resource_aws_comprehend_document_classifier, mode must be one of: MULTI_CLASS or MULTI_LABEL."
  }
}

variable "model_kms_key_id" {
  description = "KMS Key used to encrypt trained Document Classifiers"
  type        = string
  default     = null
}

variable "output_data_config" {
  description = "Configuration for the output results of training"
  type = object({
    kms_key_id = optional(string)
    s3_uri     = string
  })
  default = null
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "version_name" {
  description = "Name for the version of the Document Classifier"
  type        = string
  default     = null

  validation {
    condition     = var.version_name == null || var.version_name == "" || can(regex("^[a-zA-Z0-9-]{1,63}$", var.version_name))
    error_message = "resource_aws_comprehend_document_classifier, version_name must be a maximum of 63 characters and can contain upper- and lower-case letters, numbers, and hypen (-)."
  }
}

variable "version_name_prefix" {
  description = "Creates a unique version name beginning with the specified prefix"
  type        = string
  default     = null

  validation {
    condition     = var.version_name_prefix == null || can(regex("^[a-zA-Z0-9-]{1,37}$", var.version_name_prefix))
    error_message = "resource_aws_comprehend_document_classifier, version_name_prefix must be a maximum of 37 characters and can contain upper- and lower-case letters, numbers, and hypen (-)."
  }
}

variable "volume_kms_key_id" {
  description = "KMS Key used to encrypt storage volumes during job processing"
  type        = string
  default     = null
}

variable "vpc_config" {
  description = "Configuration parameters for VPC to contain Document Classifier resources"
  type = object({
    security_group_ids = list(string)
    subnets            = list(string)
  })
  default = null
}

variable "timeouts" {
  description = "Timeouts configuration"
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