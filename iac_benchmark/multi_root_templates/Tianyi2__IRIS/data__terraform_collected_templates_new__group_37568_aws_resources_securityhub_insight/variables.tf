variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the custom insight"
  type        = string
  validation {
    condition     = can(regex("^[\\w\\-\\.]+$", var.name))
    error_message = "resource_aws_securityhub_insight, name must be a valid insight name."
  }
}

variable "group_by_attribute" {
  description = "The attribute used to group the findings for the insight"
  type        = string
  validation {
    condition = contains([
      "AwsAccountId", "ComplianceStatus", "Confidence", "CreatedAt", "Criticality",
      "Description", "FirstObservedAt", "GeneratorId", "Id", "LastObservedAt",
      "NetworkDestinationIpV4", "NetworkDestinationIpV6", "NetworkDestinationPort",
      "NetworkDirection", "NetworkProtocol", "NetworkSourceDomain", "NetworkSourceIpV4",
      "NetworkSourceIpV6", "NetworkSourceMac", "NetworkSourcePort", "ProductArn",
      "ProductName", "RecordState", "RelatedFindingsId", "RelatedFindingsProductArn",
      "ResourceId", "ResourcePartition", "ResourceRegion", "ResourceTags", "ResourceType",
      "SeverityLabel", "SourceUrl", "Title", "Type", "UpdatedAt", "VerificationState",
      "WorkflowStatus"
    ], var.group_by_attribute)
    error_message = "resource_aws_securityhub_insight, group_by_attribute must be a valid grouping attribute."
  }
}

variable "filters" {
  description = "A configuration block including one or more (up to 10 distinct) attributes used to filter the findings included in the insight"
  type = object({
    aws_account_id = optional(list(object({
      comparison = string
      value      = string
    })))
    company_name = optional(list(object({
      comparison = string
      value      = string
    })))
    compliance_status = optional(list(object({
      comparison = string
      value      = string
    })))
    confidence = optional(list(object({
      eq  = optional(string)
      gte = optional(string)
      lte = optional(string)
    })))
    created_at = optional(list(object({
      date_range = optional(object({
        unit  = string
        value = number
      }))
      end   = optional(string)
      start = optional(string)
    })))
    criticality = optional(list(object({
      eq  = optional(string)
      gte = optional(string)
      lte = optional(string)
    })))
    description = optional(list(object({
      comparison = string
      value      = string
    })))
    finding_provider_fields_confidence = optional(list(object({
      eq  = optional(string)
      gte = optional(string)
      lte = optional(string)
    })))
    finding_provider_fields_criticality = optional(list(object({
      eq  = optional(string)
      gte = optional(string)
      lte = optional(string)
    })))
    finding_provider_fields_related_findings_id = optional(list(object({
      comparison = string
      value      = string
    })))
    finding_provider_fields_related_findings_product_arn = optional(list(object({
      comparison = string
      value      = string
    })))
    finding_provider_fields_severity_label = optional(list(object({
      comparison = string
      value      = string
    })))
    finding_provider_fields_severity_original = optional(list(object({
      comparison = string
      value      = string
    })))
    finding_provider_fields_types = optional(list(object({
      comparison = string
      value      = string
    })))
    first_observed_at = optional(list(object({
      date_range = optional(object({
        unit  = string
        value = number
      }))
      end   = optional(string)
      start = optional(string)
    })))
    generator_id = optional(list(object({
      comparison = string
      value      = string
    })))
    id = optional(list(object({
      comparison = string
      value      = string
    })))
    keyword = optional(list(object({
      value = string
    })))
    last_observed_at = optional(list(object({
      date_range = optional(object({
        unit  = string
        value = number
      }))
      end   = optional(string)
      start = optional(string)
    })))
    malware_name = optional(list(object({
      comparison = string
      value      = string
    })))
    malware_path = optional(list(object({
      comparison = string
      value      = string
    })))
    malware_state = optional(list(object({
      comparison = string
      value      = string
    })))
    malware_type = optional(list(object({
      comparison = string
      value      = string
    })))
    network_destination_domain = optional(list(object({
      comparison = string
      value      = string
    })))
    network_destination_ipv4 = optional(list(object({
      cidr = string
    })))
    network_destination_ipv6 = optional(list(object({
      cidr = string
    })))
    network_destination_port = optional(list(object({
      eq  = optional(string)
      gte = optional(string)
      lte = optional(string)
    })))
    network_direction = optional(list(object({
      comparison = string
      value      = string
    })))
    network_protocol = optional(list(object({
      comparison = string
      value      = string
    })))
    network_source_domain = optional(list(object({
      comparison = string
      value      = string
    })))
    network_source_ipv4 = optional(list(object({
      cidr = string
    })))
    network_source_ipv6 = optional(list(object({
      cidr = string
    })))
    network_source_mac = optional(list(object({
      comparison = string
      value      = string
    })))
    network_source_port = optional(list(object({
      eq  = optional(string)
      gte = optional(string)
      lte = optional(string)
    })))
    note_text = optional(list(object({
      comparison = string
      value      = string
    })))
    note_updated_at = optional(list(object({
      date_range = optional(object({
        unit  = string
        value = number
      }))
      end   = optional(string)
      start = optional(string)
    })))
    note_updated_by = optional(list(object({
      comparison = string
      value      = string
    })))
    process_launched_at = optional(list(object({
      date_range = optional(object({
        unit  = string
        value = number
      }))
      end   = optional(string)
      start = optional(string)
    })))
    process_name = optional(list(object({
      comparison = string
      value      = string
    })))
    process_parent_pid = optional(list(object({
      eq  = optional(string)
      gte = optional(string)
      lte = optional(string)
    })))
    process_path = optional(list(object({
      comparison = string
      value      = string
    })))
    process_pid = optional(list(object({
      eq  = optional(string)
      gte = optional(string)
      lte = optional(string)
    })))
    process_terminated_at = optional(list(object({
      date_range = optional(object({
        unit  = string
        value = number
      }))
      end   = optional(string)
      start = optional(string)
    })))
    product_arn = optional(list(object({
      comparison = string
      value      = string
    })))
    product_fields = optional(list(object({
      comparison = string
      key        = string
      value      = string
    })))
    product_name = optional(list(object({
      comparison = string
      value      = string
    })))
    recommendation_text = optional(list(object({
      comparison = string
      value      = string
    })))
    record_state = optional(list(object({
      comparison = string
      value      = string
    })))
    related_findings_id = optional(list(object({
      comparison = string
      value      = string
    })))
    related_findings_product_arn = optional(list(object({
      comparison = string
      value      = string
    })))
    resource_aws_ec2_instance_iam_instance_profile_arn = optional(list(object({
      comparison = string
      value      = string
    })))
    resource_aws_ec2_instance_image_id = optional(list(object({
      comparison = string
      value      = string
    })))
    resource_aws_ec2_instance_ipv4_addresses = optional(list(object({
      cidr = string
    })))
    resource_aws_ec2_instance_ipv6_addresses = optional(list(object({
      cidr = string
    })))
    resource_aws_ec2_instance_key_name = optional(list(object({
      comparison = string
      value      = string
    })))
    resource_aws_ec2_instance_launched_at = optional(list(object({
      date_range = optional(object({
        unit  = string
        value = number
      }))
      end   = optional(string)
      start = optional(string)
    })))
    resource_aws_ec2_instance_subnet_id = optional(list(object({
      comparison = string
      value      = string
    })))
    resource_aws_ec2_instance_type = optional(list(object({
      comparison = string
      value      = string
    })))
    resource_aws_ec2_instance_vpc_id = optional(list(object({
      comparison = string
      value      = string
    })))
    resource_aws_iam_access_key_created_at = optional(list(object({
      date_range = optional(object({
        unit  = string
        value = number
      }))
      end   = optional(string)
      start = optional(string)
    })))
    resource_aws_iam_access_key_status = optional(list(object({
      comparison = string
      value      = string
    })))
    resource_aws_iam_access_key_user_name = optional(list(object({
      comparison = string
      value      = string
    })))
    resource_aws_s3_bucket_owner_id = optional(list(object({
      comparison = string
      value      = string
    })))
    resource_aws_s3_bucket_owner_name = optional(list(object({
      comparison = string
      value      = string
    })))
    resource_container_image_id = optional(list(object({
      comparison = string
      value      = string
    })))
    resource_container_image_name = optional(list(object({
      comparison = string
      value      = string
    })))
    resource_container_launched_at = optional(list(object({
      date_range = optional(object({
        unit  = string
        value = number
      }))
      end   = optional(string)
      start = optional(string)
    })))
    resource_container_name = optional(list(object({
      comparison = string
      value      = string
    })))
    resource_details_other = optional(list(object({
      comparison = string
      key        = string
      value      = string
    })))
    resource_id = optional(list(object({
      comparison = string
      value      = string
    })))
    resource_partition = optional(list(object({
      comparison = string
      value      = string
    })))
    resource_region = optional(list(object({
      comparison = string
      value      = string
    })))
    resource_tags = optional(list(object({
      comparison = string
      key        = string
      value      = string
    })))
    resource_type = optional(list(object({
      comparison = string
      value      = string
    })))
    severity_label = optional(list(object({
      comparison = string
      value      = string
    })))
    source_url = optional(list(object({
      comparison = string
      value      = string
    })))
    threat_intel_indicator_category = optional(list(object({
      comparison = string
      value      = string
    })))
    threat_intel_indicator_last_observed_at = optional(list(object({
      date_range = optional(object({
        unit  = string
        value = number
      }))
      end   = optional(string)
      start = optional(string)
    })))
    threat_intel_indicator_source = optional(list(object({
      comparison = string
      value      = string
    })))
    threat_intel_indicator_source_url = optional(list(object({
      comparison = string
      value      = string
    })))
    threat_intel_indicator_type = optional(list(object({
      comparison = string
      value      = string
    })))
    threat_intel_indicator_value = optional(list(object({
      comparison = string
      value      = string
    })))
    title = optional(list(object({
      comparison = string
      value      = string
    })))
    type = optional(list(object({
      comparison = string
      value      = string
    })))
    updated_at = optional(list(object({
      date_range = optional(object({
        unit  = string
        value = number
      }))
      end   = optional(string)
      start = optional(string)
    })))
    user_defined_values = optional(list(object({
      comparison = string
      key        = string
      value      = string
    })))
    verification_state = optional(list(object({
      comparison = string
      value      = string
    })))
    workflow_status = optional(list(object({
      comparison = string
      value      = string
    })))
  })

  validation {
    condition     = can(var.filters)
    error_message = "resource_aws_securityhub_insight, filters must be a valid filters configuration block."
  }

  validation {
    condition = alltrue([
      for filter in var.filters.confidence != null ? var.filters.confidence : [] :
      (filter.eq != null ? 1 : 0) + (filter.gte != null ? 1 : 0) + (filter.lte != null ? 1 : 0) == 1
    ])
    error_message = "resource_aws_securityhub_insight, confidence filter must have exactly one of eq, gte, or lte specified."
  }

  validation {
    condition = alltrue([
      for filter in var.filters.created_at != null ? var.filters.created_at : [] :
      (filter.date_range != null && filter.start == null && filter.end == null) ||
      (filter.date_range == null && filter.start != null && filter.end != null)
    ])
    error_message = "resource_aws_securityhub_insight, created_at filter must have either date_range or both start and end specified."
  }

  validation {
    condition = alltrue([
      for filter in var.filters.created_at != null ? var.filters.created_at : [] :
      filter.date_range != null ? contains(["DAYS"], filter.date_range.unit) : true
    ])
    error_message = "resource_aws_securityhub_insight, created_at date_range unit must be DAYS."
  }

  validation {
    condition = alltrue([
      for filter in var.filters.criticality != null ? var.filters.criticality : [] :
      (filter.eq != null ? 1 : 0) + (filter.gte != null ? 1 : 0) + (filter.lte != null ? 1 : 0) == 1
    ])
    error_message = "resource_aws_securityhub_insight, criticality filter must have exactly one of eq, gte, or lte specified."
  }

  validation {
    condition = alltrue([
      for string_filter in flatten([
        var.filters.aws_account_id != null ? var.filters.aws_account_id : [],
        var.filters.company_name != null ? var.filters.company_name : [],
        var.filters.compliance_status != null ? var.filters.compliance_status : [],
        var.filters.description != null ? var.filters.description : []
      ]) : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], string_filter.comparison)
    ])
    error_message = "resource_aws_securityhub_insight, string filter comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }

  validation {
    condition = alltrue([
      for map_filter in flatten([
        var.filters.product_fields != null ? var.filters.product_fields : [],
        var.filters.resource_details_other != null ? var.filters.resource_details_other : [],
        var.filters.resource_tags != null ? var.filters.resource_tags : [],
        var.filters.user_defined_values != null ? var.filters.user_defined_values : []
      ]) : contains(["EQUALS", "NOT_EQUALS"], map_filter.comparison)
    ])
    error_message = "resource_aws_securityhub_insight, map filter comparison must be one of: EQUALS, NOT_EQUALS."
  }

  validation {
    condition = alltrue([
      for workflow_filter in var.filters.workflow_status != null ? var.filters.workflow_status : [] :
      contains(["NEW", "NOTIFIED", "SUPPRESSED", "RESOLVED"], workflow_filter.value)
    ])
    error_message = "resource_aws_securityhub_insight, workflow_status filter value must be one of: NEW, NOTIFIED, SUPPRESSED, RESOLVED."
  }
}