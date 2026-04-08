variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null
}

variable "custom_permissions_name" {
  description = "Custom permissions profile name."
  type        = string

  validation {
    condition     = length(var.custom_permissions_name) > 0
    error_message = "resource_aws_quicksight_custom_permissions, custom_permissions_name must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}

variable "capabilities" {
  description = "Actions to include in the custom permissions profile."
  type = object({
    add_or_run_anomaly_detection_for_analyses  = optional(string)
    create_and_update_dashboard_email_reports  = optional(string)
    create_and_update_datasets                 = optional(string)
    create_and_update_data_sources             = optional(string)
    create_and_update_themes                   = optional(string)
    create_and_update_threshold_alerts         = optional(string)
    create_shared_folders                      = optional(string)
    create_spice_dataset                       = optional(string)
    export_to_csv                              = optional(string)
    export_to_csv_in_scheduled_reports         = optional(string)
    export_to_excel                            = optional(string)
    export_to_excel_in_scheduled_reports       = optional(string)
    export_to_pdf                              = optional(string)
    export_to_pdf_in_scheduled_reports         = optional(string)
    include_content_in_scheduled_reports_email = optional(string)
    print_reports                              = optional(string)
    rename_shared_folders                      = optional(string)
    share_analyses                             = optional(string)
    share_dashboards                           = optional(string)
    share_datasets                             = optional(string)
    share_data_sources                         = optional(string)
    subscribe_dashboard_email_reports          = optional(string)
    view_account_spice_capacity                = optional(string)
  })

  validation {
    condition = alltrue([
      for k, v in var.capabilities : v == null || v == "DENY"
    ])
    error_message = "resource_aws_quicksight_custom_permissions, capabilities - all capability values must be 'DENY' or null."
  }

  validation {
    condition     = var.capabilities.add_or_run_anomaly_detection_for_analyses == null || var.capabilities.add_or_run_anomaly_detection_for_analyses == "DENY"
    error_message = "resource_aws_quicksight_custom_permissions, add_or_run_anomaly_detection_for_analyses must be 'DENY' or null."
  }

  validation {
    condition     = var.capabilities.create_and_update_dashboard_email_reports == null || var.capabilities.create_and_update_dashboard_email_reports == "DENY"
    error_message = "resource_aws_quicksight_custom_permissions, create_and_update_dashboard_email_reports must be 'DENY' or null."
  }

  validation {
    condition     = var.capabilities.create_and_update_datasets == null || var.capabilities.create_and_update_datasets == "DENY"
    error_message = "resource_aws_quicksight_custom_permissions, create_and_update_datasets must be 'DENY' or null."
  }

  validation {
    condition     = var.capabilities.create_and_update_data_sources == null || var.capabilities.create_and_update_data_sources == "DENY"
    error_message = "resource_aws_quicksight_custom_permissions, create_and_update_data_sources must be 'DENY' or null."
  }

  validation {
    condition     = var.capabilities.create_and_update_themes == null || var.capabilities.create_and_update_themes == "DENY"
    error_message = "resource_aws_quicksight_custom_permissions, create_and_update_themes must be 'DENY' or null."
  }

  validation {
    condition     = var.capabilities.create_and_update_threshold_alerts == null || var.capabilities.create_and_update_threshold_alerts == "DENY"
    error_message = "resource_aws_quicksight_custom_permissions, create_and_update_threshold_alerts must be 'DENY' or null."
  }

  validation {
    condition     = var.capabilities.create_shared_folders == null || var.capabilities.create_shared_folders == "DENY"
    error_message = "resource_aws_quicksight_custom_permissions, create_shared_folders must be 'DENY' or null."
  }

  validation {
    condition     = var.capabilities.create_spice_dataset == null || var.capabilities.create_spice_dataset == "DENY"
    error_message = "resource_aws_quicksight_custom_permissions, create_spice_dataset must be 'DENY' or null."
  }

  validation {
    condition     = var.capabilities.export_to_csv == null || var.capabilities.export_to_csv == "DENY"
    error_message = "resource_aws_quicksight_custom_permissions, export_to_csv must be 'DENY' or null."
  }

  validation {
    condition     = var.capabilities.export_to_csv_in_scheduled_reports == null || var.capabilities.export_to_csv_in_scheduled_reports == "DENY"
    error_message = "resource_aws_quicksight_custom_permissions, export_to_csv_in_scheduled_reports must be 'DENY' or null."
  }

  validation {
    condition     = var.capabilities.export_to_excel == null || var.capabilities.export_to_excel == "DENY"
    error_message = "resource_aws_quicksight_custom_permissions, export_to_excel must be 'DENY' or null."
  }

  validation {
    condition     = var.capabilities.export_to_excel_in_scheduled_reports == null || var.capabilities.export_to_excel_in_scheduled_reports == "DENY"
    error_message = "resource_aws_quicksight_custom_permissions, export_to_excel_in_scheduled_reports must be 'DENY' or null."
  }

  validation {
    condition     = var.capabilities.export_to_pdf == null || var.capabilities.export_to_pdf == "DENY"
    error_message = "resource_aws_quicksight_custom_permissions, export_to_pdf must be 'DENY' or null."
  }

  validation {
    condition     = var.capabilities.export_to_pdf_in_scheduled_reports == null || var.capabilities.export_to_pdf_in_scheduled_reports == "DENY"
    error_message = "resource_aws_quicksight_custom_permissions, export_to_pdf_in_scheduled_reports must be 'DENY' or null."
  }

  validation {
    condition     = var.capabilities.include_content_in_scheduled_reports_email == null || var.capabilities.include_content_in_scheduled_reports_email == "DENY"
    error_message = "resource_aws_quicksight_custom_permissions, include_content_in_scheduled_reports_email must be 'DENY' or null."
  }

  validation {
    condition     = var.capabilities.print_reports == null || var.capabilities.print_reports == "DENY"
    error_message = "resource_aws_quicksight_custom_permissions, print_reports must be 'DENY' or null."
  }

  validation {
    condition     = var.capabilities.rename_shared_folders == null || var.capabilities.rename_shared_folders == "DENY"
    error_message = "resource_aws_quicksight_custom_permissions, rename_shared_folders must be 'DENY' or null."
  }

  validation {
    condition     = var.capabilities.share_analyses == null || var.capabilities.share_analyses == "DENY"
    error_message = "resource_aws_quicksight_custom_permissions, share_analyses must be 'DENY' or null."
  }

  validation {
    condition     = var.capabilities.share_dashboards == null || var.capabilities.share_dashboards == "DENY"
    error_message = "resource_aws_quicksight_custom_permissions, share_dashboards must be 'DENY' or null."
  }

  validation {
    condition     = var.capabilities.share_datasets == null || var.capabilities.share_datasets == "DENY"
    error_message = "resource_aws_quicksight_custom_permissions, share_datasets must be 'DENY' or null."
  }

  validation {
    condition     = var.capabilities.share_data_sources == null || var.capabilities.share_data_sources == "DENY"
    error_message = "resource_aws_quicksight_custom_permissions, share_data_sources must be 'DENY' or null."
  }

  validation {
    condition     = var.capabilities.subscribe_dashboard_email_reports == null || var.capabilities.subscribe_dashboard_email_reports == "DENY"
    error_message = "resource_aws_quicksight_custom_permissions, subscribe_dashboard_email_reports must be 'DENY' or null."
  }

  validation {
    condition     = var.capabilities.view_account_spice_capacity == null || var.capabilities.view_account_spice_capacity == "DENY"
    error_message = "resource_aws_quicksight_custom_permissions, view_account_spice_capacity must be 'DENY' or null."
  }
}