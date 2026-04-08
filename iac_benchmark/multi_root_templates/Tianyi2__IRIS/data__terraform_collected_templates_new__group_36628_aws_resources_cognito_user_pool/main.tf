resource "aws_cognito_user_pool" "this" {
  region                     = var.region
  name                       = var.name
  deletion_protection        = var.deletion_protection
  alias_attributes           = var.alias_attributes
  auto_verified_attributes   = var.auto_verified_attributes
  email_verification_message = var.email_verification_message
  email_verification_subject = var.email_verification_subject
  mfa_configuration          = var.mfa_configuration
  sms_authentication_message = var.sms_authentication_message
  sms_verification_message   = var.sms_verification_message
  user_pool_tier             = var.user_pool_tier
  username_attributes        = var.username_attributes
  tags                       = var.tags

  dynamic "account_recovery_setting" {
    for_each = var.account_recovery_setting != null ? [var.account_recovery_setting] : []
    content {
      dynamic "recovery_mechanism" {
        for_each = account_recovery_setting.value.recovery_mechanism
        content {
          name     = recovery_mechanism.value.name
          priority = recovery_mechanism.value.priority
        }
      }
    }
  }

  dynamic "admin_create_user_config" {
    for_each = var.admin_create_user_config != null ? [var.admin_create_user_config] : []
    content {
      allow_admin_create_user_only = admin_create_user_config.value.allow_admin_create_user_only

      dynamic "invite_message_template" {
        for_each = admin_create_user_config.value.invite_message_template != null ? [admin_create_user_config.value.invite_message_template] : []
        content {
          email_message = invite_message_template.value.email_message
          email_subject = invite_message_template.value.email_subject
          sms_message   = invite_message_template.value.sms_message
        }
      }
    }
  }

  dynamic "device_configuration" {
    for_each = var.device_configuration != null ? [var.device_configuration] : []
    content {
      challenge_required_on_new_device      = device_configuration.value.challenge_required_on_new_device
      device_only_remembered_on_user_prompt = device_configuration.value.device_only_remembered_on_user_prompt
    }
  }

  dynamic "email_configuration" {
    for_each = var.email_configuration != null ? [var.email_configuration] : []
    content {
      configuration_set      = email_configuration.value.configuration_set
      email_sending_account  = email_configuration.value.email_sending_account
      from_email_address     = email_configuration.value.from_email_address
      reply_to_email_address = email_configuration.value.reply_to_email_address
      source_arn             = email_configuration.value.source_arn
    }
  }

  dynamic "email_mfa_configuration" {
    for_each = var.email_mfa_configuration != null ? [var.email_mfa_configuration] : []
    content {
      message = email_mfa_configuration.value.message
      subject = email_mfa_configuration.value.subject
    }
  }

  dynamic "lambda_config" {
    for_each = var.lambda_config != null ? [var.lambda_config] : []
    content {
      create_auth_challenge          = lambda_config.value.create_auth_challenge
      custom_message                 = lambda_config.value.custom_message
      define_auth_challenge          = lambda_config.value.define_auth_challenge
      post_authentication            = lambda_config.value.post_authentication
      post_confirmation              = lambda_config.value.post_confirmation
      pre_authentication             = lambda_config.value.pre_authentication
      pre_sign_up                    = lambda_config.value.pre_sign_up
      pre_token_generation           = lambda_config.value.pre_token_generation
      user_migration                 = lambda_config.value.user_migration
      verify_auth_challenge_response = lambda_config.value.verify_auth_challenge_response
      kms_key_id                     = lambda_config.value.kms_key_id

      dynamic "pre_token_generation_config" {
        for_each = lambda_config.value.pre_token_generation_config != null ? [lambda_config.value.pre_token_generation_config] : []
        content {
          lambda_arn     = pre_token_generation_config.value.lambda_arn
          lambda_version = pre_token_generation_config.value.lambda_version
        }
      }

      dynamic "custom_email_sender" {
        for_each = lambda_config.value.custom_email_sender != null ? [lambda_config.value.custom_email_sender] : []
        content {
          lambda_arn     = custom_email_sender.value.lambda_arn
          lambda_version = custom_email_sender.value.lambda_version
        }
      }

      dynamic "custom_sms_sender" {
        for_each = lambda_config.value.custom_sms_sender != null ? [lambda_config.value.custom_sms_sender] : []
        content {
          lambda_arn     = custom_sms_sender.value.lambda_arn
          lambda_version = custom_sms_sender.value.lambda_version
        }
      }
    }
  }

  dynamic "password_policy" {
    for_each = var.password_policy != null ? [var.password_policy] : []
    content {
      minimum_length                   = password_policy.value.minimum_length
      password_history_size            = password_policy.value.password_history_size
      require_lowercase                = password_policy.value.require_lowercase
      require_numbers                  = password_policy.value.require_numbers
      require_symbols                  = password_policy.value.require_symbols
      require_uppercase                = password_policy.value.require_uppercase
      temporary_password_validity_days = password_policy.value.temporary_password_validity_days
    }
  }

  dynamic "sign_in_policy" {
    for_each = var.sign_in_policy != null ? [var.sign_in_policy] : []
    content {
      allowed_first_auth_factors = sign_in_policy.value.allowed_first_auth_factors
    }
  }

  dynamic "schema" {
    for_each = var.schema != null ? var.schema : []
    content {
      attribute_data_type      = schema.value.attribute_data_type
      developer_only_attribute = schema.value.developer_only_attribute
      mutable                  = schema.value.mutable
      name                     = schema.value.name
      required                 = schema.value.required

      dynamic "number_attribute_constraints" {
        for_each = schema.value.number_attribute_constraints != null ? [schema.value.number_attribute_constraints] : []
        content {
          max_value = number_attribute_constraints.value.max_value
          min_value = number_attribute_constraints.value.min_value
        }
      }

      dynamic "string_attribute_constraints" {
        for_each = schema.value.string_attribute_constraints != null ? [schema.value.string_attribute_constraints] : []
        content {
          max_length = string_attribute_constraints.value.max_length
          min_length = string_attribute_constraints.value.min_length
        }
      }
    }
  }

  dynamic "sms_configuration" {
    for_each = var.sms_configuration != null ? [var.sms_configuration] : []
    content {
      external_id    = sms_configuration.value.external_id
      sns_caller_arn = sms_configuration.value.sns_caller_arn
      sns_region     = sms_configuration.value.sns_region
    }
  }

  dynamic "software_token_mfa_configuration" {
    for_each = var.software_token_mfa_configuration != null ? [var.software_token_mfa_configuration] : []
    content {
      enabled = software_token_mfa_configuration.value.enabled
    }
  }

  dynamic "user_attribute_update_settings" {
    for_each = var.user_attribute_update_settings != null ? [var.user_attribute_update_settings] : []
    content {
      attributes_require_verification_before_update = user_attribute_update_settings.value.attributes_require_verification_before_update
    }
  }

  dynamic "user_pool_add_ons" {
    for_each = var.user_pool_add_ons != null ? [var.user_pool_add_ons] : []
    content {
      advanced_security_mode = user_pool_add_ons.value.advanced_security_mode

      dynamic "advanced_security_additional_flows" {
        for_each = user_pool_add_ons.value.advanced_security_additional_flows != null ? [user_pool_add_ons.value.advanced_security_additional_flows] : []
        content {
          custom_auth_mode = advanced_security_additional_flows.value.custom_auth_mode
        }
      }
    }
  }

  dynamic "username_configuration" {
    for_each = var.username_configuration != null ? [var.username_configuration] : []
    content {
      case_sensitive = username_configuration.value.case_sensitive
    }
  }

  dynamic "verification_message_template" {
    for_each = var.verification_message_template != null ? [var.verification_message_template] : []
    content {
      default_email_option  = verification_message_template.value.default_email_option
      email_message         = verification_message_template.value.email_message
      email_message_by_link = verification_message_template.value.email_message_by_link
      email_subject         = verification_message_template.value.email_subject
      email_subject_by_link = verification_message_template.value.email_subject_by_link
      sms_message           = verification_message_template.value.sms_message
    }
  }

  dynamic "web_authn_configuration" {
    for_each = var.web_authn_configuration != null ? [var.web_authn_configuration] : []
    content {
      relying_party_id  = web_authn_configuration.value.relying_party_id
      user_verification = web_authn_configuration.value.user_verification
    }
  }
}