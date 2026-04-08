variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "event_configurations" {
  description = "Map. The new event configuration values. You can use only these strings as keys: THING_GROUP_HIERARCHY, THING_GROUP_MEMBERSHIP, THING_TYPE, THING_TYPE_ASSOCIATION, THING_GROUP, THING, POLICY, CA_CERTIFICATE, JOB_EXECUTION, CERTIFICATE, JOB. Use boolean for values of mapping."
  type        = map(bool)

  validation {
    condition = alltrue([
      for key in keys(var.event_configurations) : contains([
        "THING_GROUP_HIERARCHY",
        "THING_GROUP_MEMBERSHIP",
        "THING_TYPE",
        "THING_TYPE_ASSOCIATION",
        "THING_GROUP",
        "THING",
        "POLICY",
        "CA_CERTIFICATE",
        "JOB_EXECUTION",
        "CERTIFICATE",
        "JOB"
      ], key)
    ])
    error_message = "resource_aws_iot_event_configurations, event_configurations keys must be one of: THING_GROUP_HIERARCHY, THING_GROUP_MEMBERSHIP, THING_TYPE, THING_TYPE_ASSOCIATION, THING_GROUP, THING, POLICY, CA_CERTIFICATE, JOB_EXECUTION, CERTIFICATE, JOB."
  }
}