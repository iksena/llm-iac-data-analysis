output "arn" {
  description = "ARN of the User Pool."
  value       = data.aws_cognito_user_pool.this.arn
}

output "account_recovery_setting" {
  description = "The available verified method a user can use to recover their password when they call ForgotPassword. You can use this setting to define a preferred method when a user has more than one method available. With this setting, SMS doesn't qualify for a valid password recovery mechanism if the user also has SMS multi-factor authentication (MFA) activated. In the absence of this setting, Amazon Cognito uses the legacy behavior to determine the recovery method where SMS is preferred through email."
  value       = data.aws_cognito_user_pool.this.account_recovery_setting
}

output "admin_create_user_config" {
  description = "The configuration for AdminCreateUser requests."
  value       = data.aws_cognito_user_pool.this.admin_create_user_config
}

output "auto_verified_attributes" {
  description = "The attributes that are auto-verified in a user pool."
  value       = data.aws_cognito_user_pool.this.auto_verified_attributes
}

output "creation_date" {
  description = "The date and time, in ISO 8601 format, when the item was created."
  value       = data.aws_cognito_user_pool.this.creation_date
}

output "custom_domain" {
  description = "A custom domain name that you provide to Amazon Cognito. This parameter applies only if you use a custom domain to host the sign-up and sign-in pages for your application. An example of a custom domain name might be auth.example.com."
  value       = data.aws_cognito_user_pool.this.custom_domain
}

output "deletion_protection" {
  description = "When active, DeletionProtection prevents accidental deletion of your user pool. Before you can delete a user pool that you have protected against deletion, you must deactivate this feature."
  value       = data.aws_cognito_user_pool.this.deletion_protection
}

output "device_configuration" {
  description = "The device-remembering configuration for a user pool. A null value indicates that you have deactivated device remembering in your user pool."
  value       = data.aws_cognito_user_pool.this.device_configuration
}

output "domain" {
  description = "The domain prefix, if the user pool has a domain associated with it."
  value       = data.aws_cognito_user_pool.this.domain
}

output "email_configuration" {
  description = "The email configuration of your user pool. The email configuration type sets your preferred sending method, AWS Region, and sender for messages from your user pool."
  value       = data.aws_cognito_user_pool.this.email_configuration
}

output "estimated_number_of_users" {
  description = "A number estimating the size of the user pool."
  value       = data.aws_cognito_user_pool.this.estimated_number_of_users
}

output "lambda_config" {
  description = "The AWS Lambda triggers associated with the user pool."
  value       = data.aws_cognito_user_pool.this.lambda_config
}

output "last_modified_date" {
  description = "The date and time, in ISO 8601 format, when the item was modified."
  value       = data.aws_cognito_user_pool.this.last_modified_date
}

output "mfa_configuration" {
  description = "Can be one of the following values: OFF | ON | OPTIONAL"
  value       = data.aws_cognito_user_pool.this.mfa_configuration
}

output "name" {
  description = "The name of the user pool."
  value       = data.aws_cognito_user_pool.this.name
}

output "schema_attributes" {
  description = "A list of the user attributes and their properties in your user pool. The attribute schema contains standard attributes, custom attributes with a custom: prefix, and developer attributes with a dev: prefix. For more information, see User pool attributes."
  value       = data.aws_cognito_user_pool.this.schema_attributes
}

output "sms_authentication_message" {
  description = "The contents of the SMS authentication message."
  value       = data.aws_cognito_user_pool.this.sms_authentication_message
}

output "sms_configuration_failure" {
  description = "The reason why the SMS configuration can't send the messages to your users."
  value       = data.aws_cognito_user_pool.this.sms_configuration_failure
}

output "sms_verification_message" {
  description = "The contents of the SMS authentication message."
  value       = data.aws_cognito_user_pool.this.sms_verification_message
}

output "tags" {
  description = "Map of tags assigned to the resource."
  value       = data.aws_cognito_user_pool.this.tags
}

output "user_pool_add_ons" {
  description = "The user pool add-ons configuration."
  value       = data.aws_cognito_user_pool.this.user_pool_add_ons
}


output "username_attributes" {
  description = "Specifies whether a user can use an email address or phone number as a username when they sign up."
  value       = data.aws_cognito_user_pool.this.username_attributes
}