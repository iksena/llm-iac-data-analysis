# Account setup
variable "profile" {
  description           = "The profile from ~/.aws/credentials file used for authentication. By default it is the default profile."
  type                  = string
  default               = "default"
}

variable "accountID" {
  description           = "ID of your AWS account. It is a required variable normally used in JSON files or while assuming a role."
  type                  = string

  validation {
    condition           = length(var.accountID) == 12
    error_message       = "Please, provide a valid account ID."
  }
  default     = "000000000000"
}

variable "region" {
  description           = "The region for the resources. By default it is eu-west-1."
  type                  = string
  default               = "eu-west-1"
}

variable "assumeRole" {
  description           = "Enable / Disable role assume. This is disabled by default and normally used for sub organization configuration."
  type                  = bool
  default               = false
}

variable "assumableRole" {
  description           = "The role the user will assume if assumeRole is enabled. By default, it is OrganizationAccountAccessRole."
  type                  = string
  default               = "OrganizationAccountAccessRole"
}

variable "password_configuration_enabled" {
  description           = "If set to true, password policy will be applied based on the configuration below."
  type                  = bool
  default               = false
}
variable "password_configuration_allow_users_to_change_password" {
  description           = "Allow IAM users to change their passwords. By default set to true."
  type                  = bool
  default               = true
}
variable "password_configuration_require_numbers" {
  description           = "If password requires at least one digit. By default set to true."
  type                  = bool
  default               = true
}
variable "password_configuration_require_symbols" {
  description           = "If password requires at least one symbol. By default set to true."
  type                  = bool
  default               = true
}
variable "password_configuration_require_lowercase_characters" {
  description           = "If password requires at least one lowercase character. By default set to true."
  type                  = bool
  default               = true
}
variable "password_configuration_require_uppercase_characters" {
  description           = "If password requires at least one uppercase character. By default set to true."
  type                  = bool
  default               = true
}
variable "password_configuration_minimum_length" {
  description           = "The minimum length of the password. By default set to 16."
  type                  = number
  default               = 16
}
variable "password_configuration_reuse_prevention" {
  description           = "How many times user must change their password before old one can be reused. By default set to 24."
  type                  = number
  default               = 24
}
variable "password_configuration_max_age" {
  description           = "How long can be the password used for before user is asked to change it. By default set to 90"
  type                  = number
  default               = 90
}

variable "analyzer_enabled" {
  description           = "Enable access analyzer. By default set to false."
  type                  = bool
  default               = false
}
variable "analyzer_type" {
  description           = "Type of the analyzer. Allowed values are ACCOUNT and ORGANIZATION. Defaults to ACCOUNT."
  type                  = string
  default               = "ACCOUNT"

  validation {
    condition           = contains(["ACCOUNT", "ORGANIZATION"], var.analyzer_type)
    error_message       = "Expected values: ACCOUNT or ORGANIZATION."
  }
}
variable "analyzer_name" {
  description           = "Name of the analyzer. By default set to: AccessAnalyzer"
  type                  = string
  default               = "AccessAnalyzer"
}

variable "saml_enabled" {
  description           = "Enable IAM SAML Provider configuration. Defaults to false."
  type                  = bool
  default               = false
}
variable "saml_name" {
  description           = "Name of the saml provider. This name is used for the file too. Defaults to SamlProvider and it would look for saml_path/SamlProvider.xml file"
  type                  = string
  default               = "SamlProvider"
}
variable "saml_path" {
  description           = "Path to xml files for iam saml configuration. Defaults to ./xml/iam"
  type                  = string
  default               = "./xml/iam"
}

variable "user_create" {
  description           = "Enable the process of user creation"
  type                  = bool
  default               = false
}
variable "user_name" {
  description           = "Name of the iam user. Defaults to user."
  type                  = string
  default               = "user"
}
variable "user_path" {
  description           = "Path in which to create the user. Defaults to /"
  type                  = string
  default               = "/"
}
variable "user_force_destroy" {
  description           = "Whether to destroy user in case he created his own keys outside terraform. Defaults to true"
  type                  = bool
  default               = true
}

variable "access_key_create" {
  description           = "Enable the process of access key creation. Defaults to false."
  type                  = bool
  default               = false
}
variable "access_key_user_name" {
  description           = "The user name for whom to create the access key. Defaults to user."
  type                  = string
  default               = "user"
}

variable "policy_create" {
  description           = "Enable the process of policy creation. The policy can be then used by a group or role."
  type                  = bool
  default               = false
}
variable "policy_name" {
  description           = "Name of the policy. Defaults to policy"
  type                  = string
  default               = "policy"
}
variable "policy_environment" {
  description           = "If specified the policy will be named as policy_name, but the json file used will be combination of both name-environment.json. Defaults to empty string."
  type                  = string
  default               = ""
}
variable "policy_path" {
  description           = "Path to json files for iam policy configuration. Defaults to ./json/iam/policy"
  type                  = string
  default               = "./json/iam/policy"
}

variable "role_create" {
  description           = "Enable the process of role creation. Defaults to false."
  type                  = bool
  default               = false
}
variable "role_name" {
  description           = "Name of the role. Defaults to role."
  type                  = string
  default               = "role"
}
variable "role_environment" {
  description           = "If specified the role will be named as role_name, but the json file used will be combination of both name-environment.json. Defaults to empty string."
  type                  = string
  default               = ""
}
variable "role_path" {
  description           = "Path to json files for iam role configuration. Defaults to ./json/iam/role"
  type                  = string
  default               = "./json/iam/role"
}
variable "role_policies" {
  description           = "List of policy arns. Can be AWS predefined or your custom ones. Defaults to empty list."
  type                  = list(string)
  default               = []
}
variable "role_session_duration" {
  description           = "Duration of the session the role can be used for. Defaults to 1 hour and can be set to 12 hours."
  type                  = number
  default               = 3600

  validation {
    condition     = var.role_session_duration >= 3600 && var.role_session_duration <= 43200 && floor(var.role_session_duration) == var.role_session_duration
    error_message = "Accepted values: 3600-43200."
  }
}

variable "group_create" {
  description           = "Enable the process of group creation. Defaults to false."
  type                  = bool
  default               = false
}
variable "group_name" {
  description           = "Name of the iam group. Defaults to group."
  type                  = string
  default               = "group"
}
variable "group_path" {
  description           = "Path in which to create the group. Defaults to /"
  type                  = string
  default               = "/"
}
variable "group_users" {
  description           = "List of user names attached to this group. Defaults to an empty list."
  type                  = list(string)
  default               = []
}
variable "group_policy" {
  description           = "An ARN of a policy that should be attached to this group. Defaults to an empty string."
  type                  = string
  default               = ""
}