variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the connector profile"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]+$", var.name))
    error_message = "resource_aws_appflow_connector_profile, name must contain only alphanumeric characters, hyphens, underscores, and periods."
  }
}

variable "connection_mode" {
  description = "Indicates the connection mode and specifies whether it is public or private"
  type        = string
  validation {
    condition     = contains(["Public", "Private"], var.connection_mode)
    error_message = "resource_aws_appflow_connector_profile, connection_mode must be one of: Public, Private."
  }
}

variable "connector_label" {
  description = "The label of the connector"
  type        = string
  default     = null
}

variable "connector_type" {
  description = "The type of connector"
  type        = string
  validation {
    condition = contains([
      "Amplitude", "CustomConnector", "CustomerProfiles", "Datadog", "Dynatrace",
      "EventBridge", "Googleanalytics", "Honeycode", "Infornexus", "LookoutMetrics",
      "Marketo", "Redshift", "S3", "Salesforce", "SAPOData", "Servicenow",
      "Singular", "Slack", "Snowflake", "Trendmicro", "Upsolver", "Veeva", "Zendesk"
    ], var.connector_type)
    error_message = "resource_aws_appflow_connector_profile, connector_type must be one of: Amplitude, CustomConnector, CustomerProfiles, Datadog, Dynatrace, EventBridge, Googleanalytics, Honeycode, Infornexus, LookoutMetrics, Marketo, Redshift, S3, Salesforce, SAPOData, Servicenow, Singular, Slack, Snowflake, Trendmicro, Upsolver, Veeva, Zendesk."
  }
}

variable "kms_arn" {
  description = "ARN of the Key Management Service (KMS) key for encryption"
  type        = string
  default     = null
  validation {
    condition     = var.kms_arn == null || can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9-]{36}$", var.kms_arn))
    error_message = "resource_aws_appflow_connector_profile, kms_arn must be a valid KMS key ARN."
  }
}

variable "connector_profile_credentials_amplitude" {
  description = "The connector-specific credentials required when using Amplitude"
  type = object({
    api_key    = string
    secret_key = string
  })
  default = null
  validation {
    condition = var.connector_profile_credentials_amplitude == null || (
      var.connector_profile_credentials_amplitude.api_key != null &&
      var.connector_profile_credentials_amplitude.secret_key != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_credentials_amplitude requires both api_key and secret_key."
  }
}

variable "connector_profile_credentials_custom_connector" {
  description = "The connector-specific credentials required when using custom connector"
  type = object({
    authentication_type = string
    api_key = optional(object({
      api_key        = string
      api_secret_key = optional(string)
    }))
    basic = optional(object({
      password = string
      username = string
    }))
    custom = optional(object({
      credentials_map            = optional(map(string))
      custom_authentication_type = string
    }))
    oauth2 = optional(object({
      access_token  = optional(string)
      client_id     = optional(string)
      client_secret = optional(string)
      refresh_token = optional(string)
      oauth_request = optional(object({
        auth_code    = optional(string)
        redirect_uri = optional(string)
      }))
    }))
  })
  default = null
  validation {
    condition = var.connector_profile_credentials_custom_connector == null || contains([
      "APIKEY", "BASIC", "CUSTOM", "OAUTH2"
    ], var.connector_profile_credentials_custom_connector.authentication_type)
    error_message = "resource_aws_appflow_connector_profile, connector_profile_credentials_custom_connector authentication_type must be one of: APIKEY, BASIC, CUSTOM, OAUTH2."
  }
}

variable "connector_profile_credentials_datadog" {
  description = "The connector-specific credentials required when using Datadog"
  type = object({
    api_key         = string
    application_key = string
  })
  default = null
  validation {
    condition = var.connector_profile_credentials_datadog == null || (
      var.connector_profile_credentials_datadog.api_key != null &&
      var.connector_profile_credentials_datadog.application_key != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_credentials_datadog requires both api_key and application_key."
  }
}

variable "connector_profile_credentials_dynatrace" {
  description = "The connector-specific credentials required when using Dynatrace"
  type = object({
    api_token = string
  })
  default = null
  validation {
    condition = var.connector_profile_credentials_dynatrace == null || (
      var.connector_profile_credentials_dynatrace.api_token != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_credentials_dynatrace requires api_token."
  }
}

variable "connector_profile_credentials_google_analytics" {
  description = "The connector-specific credentials required when using Google Analytics"
  type = object({
    access_token  = optional(string)
    client_id     = string
    client_secret = string
    refresh_token = optional(string)
    oauth_request = optional(object({
      auth_code    = optional(string)
      redirect_uri = optional(string)
    }))
  })
  default = null
  validation {
    condition = var.connector_profile_credentials_google_analytics == null || (
      var.connector_profile_credentials_google_analytics.client_id != null &&
      var.connector_profile_credentials_google_analytics.client_secret != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_credentials_google_analytics requires both client_id and client_secret."
  }
}

variable "connector_profile_credentials_honeycode" {
  description = "The connector-specific credentials required when using Amazon Honeycode"
  type = object({
    access_token  = optional(string)
    refresh_token = optional(string)
    oauth_request = optional(object({
      auth_code    = optional(string)
      redirect_uri = optional(string)
    }))
  })
  default = null
}

variable "connector_profile_credentials_infor_nexus" {
  description = "The connector-specific credentials required when using Infor Nexus"
  type = object({
    access_key_id     = string
    datakey           = string
    secret_access_key = string
    user_id           = string
  })
  default = null
  validation {
    condition = var.connector_profile_credentials_infor_nexus == null || (
      var.connector_profile_credentials_infor_nexus.access_key_id != null &&
      var.connector_profile_credentials_infor_nexus.datakey != null &&
      var.connector_profile_credentials_infor_nexus.secret_access_key != null &&
      var.connector_profile_credentials_infor_nexus.user_id != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_credentials_infor_nexus requires all of: access_key_id, datakey, secret_access_key, user_id."
  }
}

variable "connector_profile_credentials_marketo" {
  description = "The connector-specific credentials required when using Marketo"
  type = object({
    access_token  = optional(string)
    client_id     = string
    client_secret = string
    oauth_request = optional(object({
      auth_code    = optional(string)
      redirect_uri = optional(string)
    }))
  })
  default = null
  validation {
    condition = var.connector_profile_credentials_marketo == null || (
      var.connector_profile_credentials_marketo.client_id != null &&
      var.connector_profile_credentials_marketo.client_secret != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_credentials_marketo requires both client_id and client_secret."
  }
}

variable "connector_profile_credentials_redshift" {
  description = "The connector-specific credentials required when using Amazon Redshift"
  type = object({
    password = string
    username = string
  })
  default = null
  validation {
    condition = var.connector_profile_credentials_redshift == null || (
      var.connector_profile_credentials_redshift.password != null &&
      var.connector_profile_credentials_redshift.username != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_credentials_redshift requires both password and username."
  }
}

variable "connector_profile_credentials_salesforce" {
  description = "The connector-specific credentials required when using Salesforce"
  type = object({
    access_token           = optional(string)
    client_credentials_arn = optional(string)
    jwt_token              = optional(string)
    oauth2_grant_type      = optional(string)
    refresh_token          = optional(string)
    oauth_request = optional(object({
      auth_code    = optional(string)
      redirect_uri = optional(string)
    }))
  })
  default = null
  validation {
    condition = var.connector_profile_credentials_salesforce == null || var.connector_profile_credentials_salesforce.oauth2_grant_type == null || contains([
      "CLIENT_CREDENTIALS", "AUTHORIZATION_CODE", "JWT_BEARER"
    ], var.connector_profile_credentials_salesforce.oauth2_grant_type)
    error_message = "resource_aws_appflow_connector_profile, connector_profile_credentials_salesforce oauth2_grant_type must be one of: CLIENT_CREDENTIALS, AUTHORIZATION_CODE, JWT_BEARER."
  }
}

variable "connector_profile_credentials_sapo_data" {
  description = "The connector-specific credentials required when using SAPOData"
  type = object({
    basic_auth_credentials = optional(object({
      password = string
      username = string
    }))
    oauth_credentials = optional(object({
      access_token  = optional(string)
      client_id     = string
      client_secret = string
      refresh_token = optional(string)
      oauth_request = optional(object({
        auth_code    = optional(string)
        redirect_uri = optional(string)
      }))
    }))
  })
  default = null
  validation {
    condition = var.connector_profile_credentials_sapo_data == null || (
      var.connector_profile_credentials_sapo_data.basic_auth_credentials != null ||
      var.connector_profile_credentials_sapo_data.oauth_credentials != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_credentials_sapo_data requires either basic_auth_credentials or oauth_credentials."
  }
}

variable "connector_profile_credentials_service_now" {
  description = "The connector-specific credentials required when using ServiceNow"
  type = object({
    password = string
    username = string
  })
  default = null
  validation {
    condition = var.connector_profile_credentials_service_now == null || (
      var.connector_profile_credentials_service_now.password != null &&
      var.connector_profile_credentials_service_now.username != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_credentials_service_now requires both password and username."
  }
}

variable "connector_profile_credentials_singular" {
  description = "The connector-specific credentials required when using Singular"
  type = object({
    api_key = string
  })
  default = null
  validation {
    condition = var.connector_profile_credentials_singular == null || (
      var.connector_profile_credentials_singular.api_key != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_credentials_singular requires api_key."
  }
}

variable "connector_profile_credentials_slack" {
  description = "The connector-specific credentials required when using Slack"
  type = object({
    access_token  = optional(string)
    client_id     = string
    client_secret = string
    oauth_request = optional(object({
      auth_code    = optional(string)
      redirect_uri = optional(string)
    }))
  })
  default = null
  validation {
    condition = var.connector_profile_credentials_slack == null || (
      var.connector_profile_credentials_slack.client_id != null &&
      var.connector_profile_credentials_slack.client_secret != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_credentials_slack requires both client_id and client_secret."
  }
}

variable "connector_profile_credentials_snowflake" {
  description = "The connector-specific credentials required when using Snowflake"
  type = object({
    password = string
    username = string
  })
  default = null
  validation {
    condition = var.connector_profile_credentials_snowflake == null || (
      var.connector_profile_credentials_snowflake.password != null &&
      var.connector_profile_credentials_snowflake.username != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_credentials_snowflake requires both password and username."
  }
}

variable "connector_profile_credentials_trendmicro" {
  description = "The connector-specific credentials required when using Trend Micro"
  type = object({
    api_secret_key = string
  })
  default = null
  validation {
    condition = var.connector_profile_credentials_trendmicro == null || (
      var.connector_profile_credentials_trendmicro.api_secret_key != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_credentials_trendmicro requires api_secret_key."
  }
}

variable "connector_profile_credentials_veeva" {
  description = "The connector-specific credentials required when using Veeva"
  type = object({
    password = string
    username = string
  })
  default = null
  validation {
    condition = var.connector_profile_credentials_veeva == null || (
      var.connector_profile_credentials_veeva.password != null &&
      var.connector_profile_credentials_veeva.username != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_credentials_veeva requires both password and username."
  }
}

variable "connector_profile_credentials_zendesk" {
  description = "The connector-specific credentials required when using Zendesk"
  type = object({
    access_token  = optional(string)
    client_id     = string
    client_secret = string
    oauth_request = optional(object({
      auth_code    = optional(string)
      redirect_uri = optional(string)
    }))
  })
  default = null
  validation {
    condition = var.connector_profile_credentials_zendesk == null || (
      var.connector_profile_credentials_zendesk.client_id != null &&
      var.connector_profile_credentials_zendesk.client_secret != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_credentials_zendesk requires both client_id and client_secret."
  }
}

variable "connector_profile_properties_custom_connector" {
  description = "The connector-specific profile properties required when using custom connector"
  type = object({
    profile_properties = optional(map(string))
    oauth2_properties = optional(object({
      oauth2_grant_type           = string
      token_url                   = string
      token_url_custom_properties = optional(map(string))
    }))
  })
  default = null
  validation {
    condition = var.connector_profile_properties_custom_connector == null || var.connector_profile_properties_custom_connector.oauth2_properties == null || contains([
      "AUTHORIZATION_CODE", "CLIENT_CREDENTIALS"
    ], var.connector_profile_properties_custom_connector.oauth2_properties.oauth2_grant_type)
    error_message = "resource_aws_appflow_connector_profile, connector_profile_properties_custom_connector oauth2_grant_type must be one of: AUTHORIZATION_CODE, CLIENT_CREDENTIALS."
  }
}

variable "connector_profile_properties_datadog" {
  description = "The connector-specific properties required when using Datadog"
  type = object({
    instance_url = string
  })
  default = null
  validation {
    condition = var.connector_profile_properties_datadog == null || (
      var.connector_profile_properties_datadog.instance_url != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_properties_datadog requires instance_url."
  }
}

variable "connector_profile_properties_dynatrace" {
  description = "The connector-specific properties required when using Dynatrace"
  type = object({
    instance_url = string
  })
  default = null
  validation {
    condition = var.connector_profile_properties_dynatrace == null || (
      var.connector_profile_properties_dynatrace.instance_url != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_properties_dynatrace requires instance_url."
  }
}

variable "connector_profile_properties_infor_nexus" {
  description = "The connector-specific properties required when using Infor Nexus"
  type = object({
    instance_url = string
  })
  default = null
  validation {
    condition = var.connector_profile_properties_infor_nexus == null || (
      var.connector_profile_properties_infor_nexus.instance_url != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_properties_infor_nexus requires instance_url."
  }
}

variable "connector_profile_properties_marketo" {
  description = "The connector-specific properties required when using Marketo"
  type = object({
    instance_url = string
  })
  default = null
  validation {
    condition = var.connector_profile_properties_marketo == null || (
      var.connector_profile_properties_marketo.instance_url != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_properties_marketo requires instance_url."
  }
}

variable "connector_profile_properties_redshift" {
  description = "The connector-specific properties required when using Amazon Redshift"
  type = object({
    bucket_name        = string
    bucket_prefix      = optional(string)
    cluster_identifier = optional(string)
    database_name      = optional(string)
    database_url       = string
    data_api_role_arn  = optional(string)
    role_arn           = string
  })
  default = null
  validation {
    condition = var.connector_profile_properties_redshift == null || (
      var.connector_profile_properties_redshift.bucket_name != null &&
      var.connector_profile_properties_redshift.database_url != null &&
      var.connector_profile_properties_redshift.role_arn != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_properties_redshift requires bucket_name, database_url, and role_arn."
  }
}

variable "connector_profile_properties_salesforce" {
  description = "The connector-specific properties required when using Salesforce"
  type = object({
    instance_url                                   = optional(string)
    is_sandbox_environment                         = optional(bool)
    use_privatelink_for_metadata_and_authorization = optional(bool)
  })
  default = null
}

variable "connector_profile_properties_sapo_data" {
  description = "The connector-specific properties required when using SAPOData"
  type = object({
    application_host_url      = string
    application_service_path  = string
    client_number             = string
    logon_language            = optional(string)
    port_number               = string
    private_link_service_name = optional(string)
    oauth_properties = optional(object({
      auth_code_url = string
      oauth_scopes  = list(string)
      token_url     = string
    }))
  })
  default = null
  validation {
    condition = var.connector_profile_properties_sapo_data == null || (
      var.connector_profile_properties_sapo_data.application_host_url != null &&
      var.connector_profile_properties_sapo_data.application_service_path != null &&
      var.connector_profile_properties_sapo_data.client_number != null &&
      var.connector_profile_properties_sapo_data.port_number != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_properties_sapo_data requires application_host_url, application_service_path, client_number, and port_number."
  }
}

variable "connector_profile_properties_service_now" {
  description = "The connector-specific properties required when using ServiceNow"
  type = object({
    instance_url = string
  })
  default = null
  validation {
    condition = var.connector_profile_properties_service_now == null || (
      var.connector_profile_properties_service_now.instance_url != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_properties_service_now requires instance_url."
  }
}

variable "connector_profile_properties_slack" {
  description = "The connector-specific properties required when using Slack"
  type = object({
    instance_url = string
  })
  default = null
  validation {
    condition = var.connector_profile_properties_slack == null || (
      var.connector_profile_properties_slack.instance_url != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_properties_slack requires instance_url."
  }
}

variable "connector_profile_properties_snowflake" {
  description = "The connector-specific properties required when using Snowflake"
  type = object({
    account_name              = optional(string)
    bucket_name               = string
    bucket_prefix             = optional(string)
    private_link_service_name = optional(string)
    region                    = optional(string)
    stage                     = string
    warehouse                 = string
  })
  default = null
  validation {
    condition = var.connector_profile_properties_snowflake == null || (
      var.connector_profile_properties_snowflake.bucket_name != null &&
      var.connector_profile_properties_snowflake.stage != null &&
      var.connector_profile_properties_snowflake.warehouse != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_properties_snowflake requires bucket_name, stage, and warehouse."
  }
}

variable "connector_profile_properties_veeva" {
  description = "The connector-specific properties required when using Veeva"
  type = object({
    instance_url = string
  })
  default = null
  validation {
    condition = var.connector_profile_properties_veeva == null || (
      var.connector_profile_properties_veeva.instance_url != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_properties_veeva requires instance_url."
  }
}

variable "connector_profile_properties_zendesk" {
  description = "The connector-specific properties required when using Zendesk"
  type = object({
    instance_url = string
  })
  default = null
  validation {
    condition = var.connector_profile_properties_zendesk == null || (
      var.connector_profile_properties_zendesk.instance_url != null
    )
    error_message = "resource_aws_appflow_connector_profile, connector_profile_properties_zendesk requires instance_url."
  }
}