variable "region" {
  type        = string
  description = "Region where this resource will be managed"
  default     = null
}

variable "name" {
  type        = string
  description = "Name of the user pool"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]+$", var.name))
    error_message = "resource_aws_cognito_user_pool, name must contain only alphanumeric characters, hyphens, periods, and underscores."
  }
}

variable "account_recovery_setting" {
  type = object({
    recovery_mechanism = list(object({
      name     = string
      priority = number
    }))
  })
  description = "Configuration block to define which verified available method a user can use to recover their forgotten password"
  default     = null

  validation {
    condition = var.account_recovery_setting == null || alltrue([
      for mechanism in var.account_recovery_setting.recovery_mechanism :
      contains(["verified_email", "verified_phone_number", "admin_only"], mechanism.name)
    ])
    error_message = "resource_aws_cognito_user_pool, account_recovery_setting recovery_mechanism name must be one of: verified_email, verified_phone_number, admin_only."
  }

  validation {
    condition = var.account_recovery_setting == null || alltrue([
      for mechanism in var.account_recovery_setting.recovery_mechanism :
      mechanism.priority >= 1
    ])
    error_message = "resource_aws_cognito_user_pool, account_recovery_setting recovery_mechanism priority must be a positive integer."
  }
}

variable "admin_create_user_config" {
  type = object({
    allow_admin_create_user_only = optional(bool)
    invite_message_template = optional(object({
      email_message = optional(string)
      email_subject = optional(string)
      sms_message   = optional(string)
    }))
  })
  description = "Configuration block for creating a new user profile"
  default     = null

  validation {
    condition = var.admin_create_user_config == null || var.admin_create_user_config.invite_message_template == null || (
      var.admin_create_user_config.invite_message_template.email_message == null ||
      (can(regex("\\{username\\}", var.admin_create_user_config.invite_message_template.email_message)) &&
      can(regex("\\{####\\}", var.admin_create_user_config.invite_message_template.email_message)))
    )
    error_message = "resource_aws_cognito_user_pool, admin_create_user_config invite_message_template email_message must contain {username} and {####} placeholders."
  }

  validation {
    condition = var.admin_create_user_config == null || var.admin_create_user_config.invite_message_template == null || (
      var.admin_create_user_config.invite_message_template.sms_message == null ||
      (can(regex("\\{username\\}", var.admin_create_user_config.invite_message_template.sms_message)) &&
      can(regex("\\{####\\}", var.admin_create_user_config.invite_message_template.sms_message)))
    )
    error_message = "resource_aws_cognito_user_pool, admin_create_user_config invite_message_template sms_message must contain {username} and {####} placeholders."
  }
}

variable "alias_attributes" {
  type        = list(string)
  description = "Attributes supported as an alias for this user pool. Conflicts with username_attributes"
  default     = null

  validation {
    condition = var.alias_attributes == null || alltrue([
      for attr in var.alias_attributes :
      contains(["phone_number", "email", "preferred_username"], attr)
    ])
    error_message = "resource_aws_cognito_user_pool, alias_attributes must be one of: phone_number, email, preferred_username."
  }
}

variable "auto_verified_attributes" {
  type        = list(string)
  description = "Attributes to be auto-verified"
  default     = null

  validation {
    condition = var.auto_verified_attributes == null || alltrue([
      for attr in var.auto_verified_attributes :
      contains(["email", "phone_number"], attr)
    ])
    error_message = "resource_aws_cognito_user_pool, auto_verified_attributes must be one of: email, phone_number."
  }
}

variable "deletion_protection" {
  type        = string
  description = "When active, DeletionProtection prevents accidental deletion of your user pool"
  default     = "INACTIVE"

  validation {
    condition     = contains(["ACTIVE", "INACTIVE"], var.deletion_protection)
    error_message = "resource_aws_cognito_user_pool, deletion_protection must be one of: ACTIVE, INACTIVE."
  }
}

variable "device_configuration" {
  type = object({
    challenge_required_on_new_device      = optional(bool)
    device_only_remembered_on_user_prompt = optional(bool)
  })
  description = "Configuration block for the user pool's device tracking"
  default     = null
}

variable "email_configuration" {
  type = object({
    configuration_set      = optional(string)
    email_sending_account  = optional(string)
    from_email_address     = optional(string)
    reply_to_email_address = optional(string)
    source_arn             = optional(string)
  })
  description = "Configuration block for configuring email"
  default     = null

  validation {
    condition     = var.email_configuration == null || var.email_configuration.email_sending_account == null || contains(["COGNITO_DEFAULT", "DEVELOPER"], var.email_configuration.email_sending_account)
    error_message = "resource_aws_cognito_user_pool, email_configuration email_sending_account must be one of: COGNITO_DEFAULT, DEVELOPER."
  }

  validation {
    condition = var.email_configuration == null || (
      var.email_configuration.from_email_address == null ||
      var.email_configuration.email_sending_account == "DEVELOPER"
    )
    error_message = "resource_aws_cognito_user_pool, email_configuration from_email_address requires email_sending_account to be DEVELOPER."
  }

  validation {
    condition = var.email_configuration == null || (
      var.email_configuration.source_arn == null ||
      var.email_configuration.email_sending_account == "DEVELOPER"
    )
    error_message = "resource_aws_cognito_user_pool, email_configuration source_arn requires email_sending_account to be DEVELOPER."
  }
}

variable "email_mfa_configuration" {
  type = object({
    message = optional(string)
    subject = optional(string)
  })
  description = "Configuration block for configuring email Multi-Factor Authentication (MFA)"
  default     = null

  validation {
    condition     = var.email_mfa_configuration == null || var.email_mfa_configuration.message == null || can(regex("\\{####\\}", var.email_mfa_configuration.message))
    error_message = "resource_aws_cognito_user_pool, email_mfa_configuration message must contain {####} placeholder."
  }
}

variable "email_verification_message" {
  type        = string
  description = "String representing the email verification message"
  default     = null

  validation {
    condition     = var.email_verification_message == null || can(regex("\\{####\\}", var.email_verification_message))
    error_message = "resource_aws_cognito_user_pool, email_verification_message must contain {####} placeholder."
  }
}

variable "email_verification_subject" {
  type        = string
  description = "String representing the email verification subject"
  default     = null
}

variable "lambda_config" {
  type = object({
    create_auth_challenge          = optional(string)
    custom_message                 = optional(string)
    define_auth_challenge          = optional(string)
    post_authentication            = optional(string)
    post_confirmation              = optional(string)
    pre_authentication             = optional(string)
    pre_sign_up                    = optional(string)
    pre_token_generation           = optional(string)
    user_migration                 = optional(string)
    verify_auth_challenge_response = optional(string)
    kms_key_id                     = optional(string)
    pre_token_generation_config = optional(object({
      lambda_arn     = string
      lambda_version = string
    }))
    custom_email_sender = optional(object({
      lambda_arn     = string
      lambda_version = string
    }))
    custom_sms_sender = optional(object({
      lambda_arn     = string
      lambda_version = string
    }))
  })
  description = "Configuration block for the AWS Lambda triggers associated with the user pool"
  default     = null

  validation {
    condition     = var.lambda_config == null || var.lambda_config.pre_token_generation_config == null || contains(["V1_0", "V2_0", "V3_0"], var.lambda_config.pre_token_generation_config.lambda_version)
    error_message = "resource_aws_cognito_user_pool, lambda_config pre_token_generation_config lambda_version must be one of: V1_0, V2_0, V3_0."
  }

  validation {
    condition     = var.lambda_config == null || var.lambda_config.custom_email_sender == null || var.lambda_config.custom_email_sender.lambda_version == "V1_0"
    error_message = "resource_aws_cognito_user_pool, lambda_config custom_email_sender lambda_version must be V1_0."
  }

  validation {
    condition     = var.lambda_config == null || var.lambda_config.custom_sms_sender == null || var.lambda_config.custom_sms_sender.lambda_version == "V1_0"
    error_message = "resource_aws_cognito_user_pool, lambda_config custom_sms_sender lambda_version must be V1_0."
  }
}

variable "mfa_configuration" {
  type        = string
  description = "Multi-Factor Authentication (MFA) configuration for the User Pool"
  default     = "OFF"

  validation {
    condition     = contains(["OFF", "ON", "OPTIONAL"], var.mfa_configuration)
    error_message = "resource_aws_cognito_user_pool, mfa_configuration must be one of: OFF, ON, OPTIONAL."
  }
}

variable "password_policy" {
  type = object({
    minimum_length                   = optional(number)
    password_history_size            = optional(number)
    require_lowercase                = optional(bool)
    require_numbers                  = optional(bool)
    require_symbols                  = optional(bool)
    require_uppercase                = optional(bool)
    temporary_password_validity_days = optional(number)
  })
  description = "Configuration block for information about the user pool password policy"
  default     = null

  validation {
    condition     = var.password_policy == null || var.password_policy.password_history_size == null || (var.password_policy.password_history_size >= 0 && var.password_policy.password_history_size <= 24)
    error_message = "resource_aws_cognito_user_pool, password_policy password_history_size must be between 0 and 24."
  }
}

variable "schema" {
  type = list(object({
    attribute_data_type      = string
    developer_only_attribute = optional(bool)
    mutable                  = optional(bool)
    name                     = string
    required                 = optional(bool)
    number_attribute_constraints = optional(object({
      max_value = optional(string)
      min_value = optional(string)
    }))
    string_attribute_constraints = optional(object({
      max_length = optional(number)
      min_length = optional(number)
    }))
  }))
  description = "Configuration block for the schema attributes of a user pool"
  default     = null

  validation {
    condition = var.schema == null || alltrue([
      for s in var.schema :
      contains(["Boolean", "Number", "String", "DateTime"], s.attribute_data_type)
    ])
    error_message = "resource_aws_cognito_user_pool, schema attribute_data_type must be one of: Boolean, Number, String, DateTime."
  }
}

variable "sign_in_policy" {
  type = object({
    allowed_first_auth_factors = optional(list(string))
  })
  description = "Configuration block for information about the user pool sign in policy"
  default     = null

  validation {
    condition = var.sign_in_policy == null || var.sign_in_policy.allowed_first_auth_factors == null || alltrue([
      for factor in var.sign_in_policy.allowed_first_auth_factors :
      contains(["PASSWORD", "EMAIL_OTP", "SMS_OTP", "WEB_AUTHN"], factor)
    ])
    error_message = "resource_aws_cognito_user_pool, sign_in_policy allowed_first_auth_factors must be one of: PASSWORD, EMAIL_OTP, SMS_OTP, WEB_AUTHN."
  }
}

variable "sms_authentication_message" {
  type        = string
  description = "String representing the SMS authentication message"
  default     = null

  validation {
    condition     = var.sms_authentication_message == null || can(regex("\\{####\\}", var.sms_authentication_message))
    error_message = "resource_aws_cognito_user_pool, sms_authentication_message must contain {####} placeholder."
  }
}

variable "sms_configuration" {
  type = object({
    external_id    = string
    sns_caller_arn = string
    sns_region     = optional(string)
  })
  description = "Configuration block for Short Message Service (SMS) settings"
  default     = null
}

variable "sms_verification_message" {
  type        = string
  description = "String representing the SMS verification message"
  default     = null

  validation {
    condition     = var.sms_verification_message == null || can(regex("\\{####\\}", var.sms_verification_message))
    error_message = "resource_aws_cognito_user_pool, sms_verification_message must contain {####} placeholder."
  }
}

variable "software_token_mfa_configuration" {
  type = object({
    enabled = bool
  })
  description = "Configuration block for software token Multi-Factor Authentication (MFA) settings"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to assign to the User Pool"
  default     = {}
}

variable "user_attribute_update_settings" {
  type = object({
    attributes_require_verification_before_update = list(string)
  })
  description = "Configuration block for user attribute update settings"
  default     = null

  validation {
    condition = var.user_attribute_update_settings == null || alltrue([
      for attr in var.user_attribute_update_settings.attributes_require_verification_before_update :
      contains(["email", "phone_number"], attr)
    ])
    error_message = "resource_aws_cognito_user_pool, user_attribute_update_settings attributes_require_verification_before_update must be one of: email, phone_number."
  }
}

variable "user_pool_add_ons" {
  type = object({
    advanced_security_mode = string
    advanced_security_additional_flows = optional(object({
      custom_auth_mode = optional(string)
    }))
  })
  description = "Configuration block for user pool add-ons to enable user pool advanced security mode features"
  default     = null

  validation {
    condition     = var.user_pool_add_ons == null || contains(["OFF", "AUDIT", "ENFORCED"], var.user_pool_add_ons.advanced_security_mode)
    error_message = "resource_aws_cognito_user_pool, user_pool_add_ons advanced_security_mode must be one of: OFF, AUDIT, ENFORCED."
  }

  validation {
    condition     = var.user_pool_add_ons == null || var.user_pool_add_ons.advanced_security_additional_flows == null || var.user_pool_add_ons.advanced_security_additional_flows.custom_auth_mode == null || contains(["AUDIT", "ENFORCED"], var.user_pool_add_ons.advanced_security_additional_flows.custom_auth_mode)
    error_message = "resource_aws_cognito_user_pool, user_pool_add_ons advanced_security_additional_flows custom_auth_mode must be one of: AUDIT, ENFORCED."
  }
}

variable "user_pool_tier" {
  type        = string
  description = "The user pool feature plan, or tier"
  default     = null

  validation {
    condition     = var.user_pool_tier == null || contains(["LITE", "ESSENTIALS", "PLUS"], var.user_pool_tier)
    error_message = "resource_aws_cognito_user_pool, user_pool_tier must be one of: LITE, ESSENTIALS, PLUS."
  }
}

variable "username_attributes" {
  type        = list(string)
  description = "Whether email addresses or phone numbers can be specified as usernames when a user signs up. Conflicts with alias_attributes"
  default     = null

  validation {
    condition = var.username_attributes == null || alltrue([
      for attr in var.username_attributes :
      contains(["email", "phone_number"], attr)
    ])
    error_message = "resource_aws_cognito_user_pool, username_attributes must be one of: email, phone_number."
  }
}

variable "username_configuration" {
  type = object({
    case_sensitive = optional(bool)
  })
  description = "Configuration block for username configuration"
  default     = null
}

variable "verification_message_template" {
  type = object({
    default_email_option  = optional(string)
    email_message         = optional(string)
    email_message_by_link = optional(string)
    email_subject         = optional(string)
    email_subject_by_link = optional(string)
    sms_message           = optional(string)
  })
  description = "Configuration block for verification message templates"
  default     = null

  validation {
    condition     = var.verification_message_template == null || var.verification_message_template.default_email_option == null || contains(["CONFIRM_WITH_CODE", "CONFIRM_WITH_LINK"], var.verification_message_template.default_email_option)
    error_message = "resource_aws_cognito_user_pool, verification_message_template default_email_option must be one of: CONFIRM_WITH_CODE, CONFIRM_WITH_LINK."
  }

  validation {
    condition     = var.verification_message_template == null || var.verification_message_template.email_message == null || can(regex("\\{####\\}", var.verification_message_template.email_message))
    error_message = "resource_aws_cognito_user_pool, verification_message_template email_message must contain {####} placeholder."
  }

  validation {
    condition     = var.verification_message_template == null || var.verification_message_template.email_message_by_link == null || can(regex("\\{##Click Here##\\}", var.verification_message_template.email_message_by_link))
    error_message = "resource_aws_cognito_user_pool, verification_message_template email_message_by_link must contain {##Click Here##} placeholder."
  }

  validation {
    condition     = var.verification_message_template == null || var.verification_message_template.sms_message == null || can(regex("\\{####\\}", var.verification_message_template.sms_message))
    error_message = "resource_aws_cognito_user_pool, verification_message_template sms_message must contain {####} placeholder."
  }
}

variable "web_authn_configuration" {
  type = object({
    relying_party_id  = optional(string)
    user_verification = optional(string)
  })
  description = "Configuration block for web authn configuration"
  default     = null

  validation {
    condition     = var.web_authn_configuration == null || var.web_authn_configuration.user_verification == null || contains(["required", "preferred"], var.web_authn_configuration.user_verification)
    error_message = "resource_aws_cognito_user_pool, web_authn_configuration user_verification must be one of: required, preferred."
  }
}