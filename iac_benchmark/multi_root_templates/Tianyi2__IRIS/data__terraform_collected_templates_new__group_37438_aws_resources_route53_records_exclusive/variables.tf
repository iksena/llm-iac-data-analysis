variable "zone_id" {
  type        = string
  description = "ID of the hosted zone containing the resource record sets."

  validation {
    condition     = can(regex("^[A-Z0-9]+$", var.zone_id))
    error_message = "resource_aws_route53_records_exclusive, zone_id must be a valid Route 53 hosted zone ID."
  }
}

variable "resource_record_set" {
  type = list(object({
    name = string
    type = string
    alias_target = optional(object({
      dns_name               = string
      evaluate_target_health = bool
      hosted_zone_id         = string
    }))
    cidr_routing_policy = optional(object({
      collection_id = string
      location_name = string
    }))
    failover = optional(string)
    geolocation = optional(object({
      continent   = optional(string)
      country     = optional(string)
      subdivision = optional(string)
    }))
    geoproximity_location = optional(object({
      aws_region       = optional(string)
      bias             = optional(number)
      local_zone_group = optional(string)
      coordinates = optional(object({
        latitude  = number
        longitude = number
      }))
    }))
    health_check_id   = optional(string)
    multivalue_answer = optional(bool)
    region            = optional(string)
    resource_records = optional(list(object({
      value = string
    })))
    set_identifier             = optional(string)
    traffic_policy_instance_id = optional(string)
    ttl                        = optional(number)
    weight                     = optional(number)
  }))
  default     = []
  description = "A list of all resource record sets associated with the hosted zone."

  validation {
    condition = alltrue([
      for rrs in var.resource_record_set : contains([
        "A", "AAAA", "CAA", "CNAME", "DS", "MX", "NAPTR", "NS", "PTR", "SOA", "SPF", "SRV", "TXT", "TLSA", "SSHFP", "SVCB", "HTTPS"
      ], rrs.type)
    ])
    error_message = "resource_aws_route53_records_exclusive, type must be one of: A, AAAA, CAA, CNAME, DS, MX, NAPTR, NS, PTR, SOA, SPF, SRV, TXT, TLSA, SSHFP, SVCB, HTTPS."
  }

  validation {
    condition = alltrue([
      for rrs in var.resource_record_set :
      (rrs.alias_target != null ? 1 : 0) + (rrs.resource_records != null ? 1 : 0) == 1
    ])
    error_message = "resource_aws_route53_records_exclusive, resource_record_set must specify exactly one of alias_target or resource_records."
  }

  validation {
    condition = alltrue([
      for rrs in var.resource_record_set :
      rrs.failover == null || contains(["PRIMARY", "SECONDARY"], rrs.failover)
    ])
    error_message = "resource_aws_route53_records_exclusive, failover must be either PRIMARY or SECONDARY when specified."
  }

  validation {
    condition = alltrue([
      for rrs in var.resource_record_set :
      rrs.geolocation == null || (
        (rrs.geolocation.continent != null ? 1 : 0) + (rrs.geolocation.country != null ? 1 : 0) >= 1
      )
    ])
    error_message = "resource_aws_route53_records_exclusive, geolocation must specify at least one of continent or country."
  }

  validation {
    condition = alltrue([
      for rrs in var.resource_record_set :
      rrs.geoproximity_location == null || rrs.geoproximity_location.coordinates == null || (
        rrs.geoproximity_location.coordinates.latitude >= -90 &&
        rrs.geoproximity_location.coordinates.latitude <= 90
      )
    ])
    error_message = "resource_aws_route53_records_exclusive, coordinates latitude must be between -90 and 90."
  }

  validation {
    condition = alltrue([
      for rrs in var.resource_record_set :
      rrs.geoproximity_location == null || rrs.geoproximity_location.coordinates == null || (
        rrs.geoproximity_location.coordinates.longitude >= -180 &&
        rrs.geoproximity_location.coordinates.longitude <= 180
      )
    ])
    error_message = "resource_aws_route53_records_exclusive, coordinates longitude must be between -180 and 180."
  }

  validation {
    condition = alltrue([
      for rrs in var.resource_record_set :
      rrs.geoproximity_location == null || rrs.geoproximity_location.bias == null || (
        rrs.geoproximity_location.bias >= -99 &&
        rrs.geoproximity_location.bias <= 99
      )
    ])
    error_message = "resource_aws_route53_records_exclusive, geoproximity_location bias must be between -99 and 99."
  }

  validation {
    condition = alltrue([
      for rrs in var.resource_record_set :
      (rrs.cidr_routing_policy != null || rrs.failover != null || rrs.geolocation != null ||
        rrs.geoproximity_location != null || rrs.multivalue_answer != null || rrs.region != null ||
      rrs.weight != null) ? rrs.set_identifier != null : true
    ])
    error_message = "resource_aws_route53_records_exclusive, set_identifier is required when using cidr_routing_policy, failover, geolocation, geoproximity_location, multivalue_answer, region, or weight."
  }

  validation {
    condition = alltrue([
      for rrs in var.resource_record_set :
      rrs.alias_target == null ? rrs.ttl != null : true
    ])
    error_message = "resource_aws_route53_records_exclusive, ttl is required for non-alias records."
  }
}

variable "timeouts" {
  type = object({
    create = optional(string, "45m")
    update = optional(string, "45m")
  })
  default     = {}
  description = "Timeouts configuration for the resource."
}