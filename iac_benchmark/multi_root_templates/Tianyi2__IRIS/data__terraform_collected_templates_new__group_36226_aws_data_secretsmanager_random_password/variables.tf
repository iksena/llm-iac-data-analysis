variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "exclude_characters" {
  type        = string
  description = "String of the characters that you don't want in the password."
  default     = null
}

variable "exclude_lowercase" {
  type        = bool
  description = "Specifies whether to exclude lowercase letters from the password."
  default     = null
}

variable "exclude_numbers" {
  type        = bool
  description = "Specifies whether to exclude numbers from the password."
  default     = null
}

variable "exclude_punctuation" {
  type        = bool
  description = "Specifies whether to exclude the following punctuation characters from the password: ! \" # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \\ ] ^ _ ` { | } ~ ."
  default     = null
}

variable "exclude_uppercase" {
  type        = bool
  description = "Specifies whether to exclude uppercase letters from the password."
  default     = null
}

variable "include_space" {
  type        = bool
  description = "Specifies whether to include the space character."
  default     = null
}

variable "password_length" {
  type        = number
  description = "Length of the password."
  default     = null

  validation {
    condition     = var.password_length == null || var.password_length > 0
    error_message = "data_aws_secretsmanager_random_password, password_length must be greater than 0."
  }
}

variable "require_each_included_type" {
  type        = bool
  description = "Specifies whether to include at least one upper and lowercase letter, one number, and one punctuation."
  default     = null
}