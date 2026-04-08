variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "description" {
  description = "The description of the rule"
  type        = string

  validation {
    condition     = length(var.description) > 0
    error_message = "resource_aws_securityhub_automation_rule, description must not be empty."
  }
}

variable "rule_name" {
  description = "The name of the rule"
  type        = string

  validation {
    condition     = length(var.rule_name) > 0
    error_message = "resource_aws_securityhub_automation_rule, rule_name must not be empty."
  }
}

variable "rule_order" {
  description = "An integer ranging from 1 to 1000 that represents the order in which the rule action is applied to findings"
  type        = number

  validation {
    condition     = var.rule_order >= 1 && var.rule_order <= 1000
    error_message = "resource_aws_securityhub_automation_rule, rule_order must be an integer between 1 and 1000."
  }
}

variable "is_terminal" {
  description = "Specifies whether a rule is the last to be applied with respect to a finding that matches the rule criteria"
  type        = bool
  default     = false
}

variable "rule_status" {
  description = "Whether the rule is active after it is created"
  type        = string
  default     = null
}

variable "actions_type" {
  description = "Specifies that the rule action should update the Types finding field"
  type        = string
  default     = "FINDING_FIELDS_UPDATE"
}

variable "finding_fields_update" {
  description = "A block that specifies that the automation rule action is an update to a finding field"
  type = object({
    confidence          = optional(number)
    criticality         = optional(number)
    types               = optional(list(string))
    user_defined_fields = optional(map(string))
    verification_state  = optional(string)
    note = optional(object({
      text       = string
      updated_by = string
    }))
    related_findings = optional(list(object({
      id          = string
      product_arn = string
    })))
    severity = optional(object({
      label   = optional(string)
      product = optional(string)
    }))
    workflow = optional(object({
      status = optional(string)
    }))
  })
  default = null

  validation {
    condition = var.finding_fields_update == null || (
      var.finding_fields_update.verification_state == null ||
      contains(["UNKNOWN", "TRUE_POSITIVE", "FALSE_POSITIVE", "BENIGN_POSITIVE"], var.finding_fields_update.verification_state)
    )
    error_message = "resource_aws_securityhub_automation_rule, verification_state must be one of: UNKNOWN, TRUE_POSITIVE, FALSE_POSITIVE, BENIGN_POSITIVE."
  }

  validation {
    condition = var.finding_fields_update == null || (
      var.finding_fields_update.severity == null ||
      var.finding_fields_update.severity.label == null ||
      contains(["INFORMATIONAL", "LOW", "MEDIUM", "HIGH", "CRITICAL"], var.finding_fields_update.severity.label)
    )
    error_message = "resource_aws_securityhub_automation_rule, severity.label must be one of: INFORMATIONAL, LOW, MEDIUM, HIGH, CRITICAL."
  }

  validation {
    condition = var.finding_fields_update == null || (
      var.finding_fields_update.workflow == null ||
      var.finding_fields_update.workflow.status == null ||
      contains(["NEW", "NOTIFIED", "RESOLVED", "SUPPRESSED"], var.finding_fields_update.workflow.status)
    )
    error_message = "resource_aws_securityhub_automation_rule, workflow.status must be one of: NEW, NOTIFIED, RESOLVED, SUPPRESSED."
  }
}

variable "criteria_aws_account_id" {
  description = "The AWS account ID in which a finding was generated"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_aws_account_id == null || alltrue([
      for filter in var.criteria_aws_account_id : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_aws_account_id comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_aws_account_name" {
  description = "The name of the AWS account in which a finding was generated"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_aws_account_name == null || alltrue([
      for filter in var.criteria_aws_account_name : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_aws_account_name comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_company_name" {
  description = "The name of the company for the product that generated the finding"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_company_name == null || alltrue([
      for filter in var.criteria_company_name : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_company_name comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_compliance_associated_standards_id" {
  description = "The unique identifier of a standard in which a control is enabled"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_compliance_associated_standards_id == null || alltrue([
      for filter in var.criteria_compliance_associated_standards_id : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_compliance_associated_standards_id comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_compliance_security_control_id" {
  description = "The security control ID for which a finding was generated"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_compliance_security_control_id == null || alltrue([
      for filter in var.criteria_compliance_security_control_id : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_compliance_security_control_id comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_compliance_status" {
  description = "The result of a security check"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_compliance_status == null || alltrue([
      for filter in var.criteria_compliance_status : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_compliance_status comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_confidence" {
  description = "The likelihood that a finding accurately identifies the behavior or issue that it was intended to identify"
  type = list(object({
    eq  = optional(string)
    gte = optional(string)
    lte = optional(string)
  }))
  default = null

  validation {
    condition = var.criteria_confidence == null || alltrue([
      for filter in var.criteria_confidence : (
        (filter.eq != null ? 1 : 0) +
        (filter.gte != null ? 1 : 0) +
        (filter.lte != null ? 1 : 0)
      ) == 1
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_confidence must specify exactly one of eq, gte, or lte."
  }
}

variable "criteria_created_at" {
  description = "A timestamp that indicates when this finding record was created"
  type = list(object({
    start = optional(string)
    end   = optional(string)
    date_range = optional(object({
      unit  = string
      value = number
    }))
  }))
  default = null

  validation {
    condition = var.criteria_created_at == null || alltrue([
      for filter in var.criteria_created_at : (
        (filter.start != null && filter.end != null && filter.date_range == null) ||
        (filter.start == null && filter.end == null && filter.date_range != null)
      )
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_created_at must specify either both start and end, or date_range."
  }

  validation {
    condition = var.criteria_created_at == null || alltrue([
      for filter in var.criteria_created_at : (
        filter.date_range == null || filter.date_range.unit == "DAYS"
      )
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_created_at date_range.unit must be DAYS."
  }
}

variable "criteria_criticality" {
  description = "The level of importance that is assigned to the resources that are associated with a finding"
  type = list(object({
    eq  = optional(string)
    gte = optional(string)
    lte = optional(string)
  }))
  default = null

  validation {
    condition = var.criteria_criticality == null || alltrue([
      for filter in var.criteria_criticality : (
        (filter.eq != null ? 1 : 0) +
        (filter.gte != null ? 1 : 0) +
        (filter.lte != null ? 1 : 0)
      ) == 1
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_criticality must specify exactly one of eq, gte, or lte."
  }
}

variable "criteria_description" {
  description = "A finding's description"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_description == null || alltrue([
      for filter in var.criteria_description : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_description comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_first_observed_at" {
  description = "A timestamp that indicates when the potential security issue captured by a finding was first observed by the security findings product"
  type = list(object({
    start = optional(string)
    end   = optional(string)
    date_range = optional(object({
      unit  = string
      value = number
    }))
  }))
  default = null

  validation {
    condition = var.criteria_first_observed_at == null || alltrue([
      for filter in var.criteria_first_observed_at : (
        (filter.start != null && filter.end != null && filter.date_range == null) ||
        (filter.start == null && filter.end == null && filter.date_range != null)
      )
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_first_observed_at must specify either both start and end, or date_range."
  }

  validation {
    condition = var.criteria_first_observed_at == null || alltrue([
      for filter in var.criteria_first_observed_at : (
        filter.date_range == null || filter.date_range.unit == "DAYS"
      )
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_first_observed_at date_range.unit must be DAYS."
  }
}

variable "criteria_generator_id" {
  description = "The identifier for the solution-specific component that generated a finding"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_generator_id == null || alltrue([
      for filter in var.criteria_generator_id : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_generator_id comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_id" {
  description = "The product-specific identifier for a finding"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_id == null || alltrue([
      for filter in var.criteria_id : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_id comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_last_observed_at" {
  description = "A timestamp that indicates when the potential security issue captured by a finding was most recently observed by the security findings product"
  type = list(object({
    start = optional(string)
    end   = optional(string)
    date_range = optional(object({
      unit  = string
      value = number
    }))
  }))
  default = null

  validation {
    condition = var.criteria_last_observed_at == null || alltrue([
      for filter in var.criteria_last_observed_at : (
        (filter.start != null && filter.end != null && filter.date_range == null) ||
        (filter.start == null && filter.end == null && filter.date_range != null)
      )
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_last_observed_at must specify either both start and end, or date_range."
  }

  validation {
    condition = var.criteria_last_observed_at == null || alltrue([
      for filter in var.criteria_last_observed_at : (
        filter.date_range == null || filter.date_range.unit == "DAYS"
      )
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_last_observed_at date_range.unit must be DAYS."
  }
}

variable "criteria_note_text" {
  description = "The text of a user-defined note that's added to a finding"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_note_text == null || alltrue([
      for filter in var.criteria_note_text : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_note_text comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_note_updated_at" {
  description = "The timestamp of when the note was updated"
  type = list(object({
    start = optional(string)
    end   = optional(string)
    date_range = optional(object({
      unit  = string
      value = number
    }))
  }))
  default = null

  validation {
    condition = var.criteria_note_updated_at == null || alltrue([
      for filter in var.criteria_note_updated_at : (
        (filter.start != null && filter.end != null && filter.date_range == null) ||
        (filter.start == null && filter.end == null && filter.date_range != null)
      )
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_note_updated_at must specify either both start and end, or date_range."
  }

  validation {
    condition = var.criteria_note_updated_at == null || alltrue([
      for filter in var.criteria_note_updated_at : (
        filter.date_range == null || filter.date_range.unit == "DAYS"
      )
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_note_updated_at date_range.unit must be DAYS."
  }
}

variable "criteria_note_updated_by" {
  description = "The principal that created a note"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_note_updated_by == null || alltrue([
      for filter in var.criteria_note_updated_by : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_note_updated_by comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_product_arn" {
  description = "The Amazon Resource Name (ARN) for a third-party product that generated a finding in Security Hub"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_product_arn == null || alltrue([
      for filter in var.criteria_product_arn : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_product_arn comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_product_name" {
  description = "Provides the name of the product that generated the finding"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_product_name == null || alltrue([
      for filter in var.criteria_product_name : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_product_name comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_record_state" {
  description = "Provides the current state of a finding"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_record_state == null || alltrue([
      for filter in var.criteria_record_state : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_record_state comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_related_findings_id" {
  description = "The product-generated identifier for a related finding"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_related_findings_id == null || alltrue([
      for filter in var.criteria_related_findings_id : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_related_findings_id comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_related_findings_product_arn" {
  description = "The ARN for the product that generated a related finding"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_related_findings_product_arn == null || alltrue([
      for filter in var.criteria_related_findings_product_arn : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_related_findings_product_arn comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_resource_application_arn" {
  description = "The Amazon Resource Name (ARN) of the application that is related to a finding"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_resource_application_arn == null || alltrue([
      for filter in var.criteria_resource_application_arn : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_resource_application_arn comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_resource_application_name" {
  description = "The name of the application that is related to a finding"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_resource_application_name == null || alltrue([
      for filter in var.criteria_resource_application_name : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_resource_application_name comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_resource_details_other" {
  description = "Custom fields and values about the resource that a finding pertains to"
  type = list(object({
    comparison = string
    key        = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_resource_details_other == null || alltrue([
      for filter in var.criteria_resource_details_other : contains(["EQUALS", "NOT_EQUALS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_resource_details_other comparison must be one of: EQUALS, NOT_EQUALS."
  }
}

variable "criteria_resource_id" {
  description = "The identifier for the given resource type"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_resource_id == null || alltrue([
      for filter in var.criteria_resource_id : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_resource_id comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_resource_partition" {
  description = "The partition in which the resource that the finding pertains to is located"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_resource_partition == null || alltrue([
      for filter in var.criteria_resource_partition : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_resource_partition comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_resource_region" {
  description = "The AWS Region where the resource that a finding pertains to is located"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_resource_region == null || alltrue([
      for filter in var.criteria_resource_region : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_resource_region comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_resource_tags" {
  description = "A list of AWS tags associated with a resource at the time the finding was processed"
  type = list(object({
    comparison = string
    key        = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_resource_tags == null || alltrue([
      for filter in var.criteria_resource_tags : contains(["EQUALS", "NOT_EQUALS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_resource_tags comparison must be one of: EQUALS, NOT_EQUALS."
  }
}

variable "criteria_resource_type" {
  description = "The type of resource that the finding pertains to"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_resource_type == null || alltrue([
      for filter in var.criteria_resource_type : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_resource_type comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_severity_label" {
  description = "The severity value of the finding"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_severity_label == null || alltrue([
      for filter in var.criteria_severity_label : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_severity_label comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_source_url" {
  description = "Provides a URL that links to a page about the current finding in the finding product"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_source_url == null || alltrue([
      for filter in var.criteria_source_url : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_source_url comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_title" {
  description = "A finding's title"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_title == null || alltrue([
      for filter in var.criteria_title : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_title comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_type" {
  description = "One or more finding types in the format of namespace/category/classifier that classify a finding"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_type == null || alltrue([
      for filter in var.criteria_type : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_type comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_updated_at" {
  description = "A timestamp that indicates when the finding record was most recently updated"
  type = list(object({
    start = optional(string)
    end   = optional(string)
    date_range = optional(object({
      unit  = string
      value = number
    }))
  }))
  default = null

  validation {
    condition = var.criteria_updated_at == null || alltrue([
      for filter in var.criteria_updated_at : (
        (filter.start != null && filter.end != null && filter.date_range == null) ||
        (filter.start == null && filter.end == null && filter.date_range != null)
      )
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_updated_at must specify either both start and end, or date_range."
  }

  validation {
    condition = var.criteria_updated_at == null || alltrue([
      for filter in var.criteria_updated_at : (
        filter.date_range == null || filter.date_range.unit == "DAYS"
      )
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_updated_at date_range.unit must be DAYS."
  }
}

variable "criteria_user_defined_fields" {
  description = "A list of user-defined name and value string pairs added to a finding"
  type = list(object({
    comparison = string
    key        = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_user_defined_fields == null || alltrue([
      for filter in var.criteria_user_defined_fields : contains(["EQUALS", "NOT_EQUALS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_user_defined_fields comparison must be one of: EQUALS, NOT_EQUALS."
  }
}

variable "criteria_verification_state" {
  description = "Provides the veracity of a finding"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_verification_state == null || alltrue([
      for filter in var.criteria_verification_state : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_verification_state comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}

variable "criteria_workflow_status" {
  description = "Provides information about the status of the investigation into a finding"
  type = list(object({
    comparison = string
    value      = string
  }))
  default = null

  validation {
    condition = var.criteria_workflow_status == null || alltrue([
      for filter in var.criteria_workflow_status : contains(["EQUALS", "PREFIX", "NOT_EQUALS", "PREFIX_NOT_EQUALS", "CONTAINS", "NOT_CONTAINS"], filter.comparison)
    ])
    error_message = "resource_aws_securityhub_automation_rule, criteria_workflow_status comparison must be one of: EQUALS, PREFIX, NOT_EQUALS, PREFIX_NOT_EQUALS, CONTAINS, NOT_CONTAINS."
  }
}