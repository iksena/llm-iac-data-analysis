variable "zone_id" {
  description = "The ID of the hosted zone to contain this record"
  type        = string
}

variable "name" {
  description = "The name of the record"
  type        = string
}

variable "type" {
  description = "The record type"
  type        = string
  validation {
    condition = contains([
      "A", "AAAA", "CAA", "CNAME", "DS", "HTTPS", "MX",
      "NAPTR", "NS", "PTR", "SOA", "SPF", "SRV", "SSHFP",
      "SVCB", "TLSA", "TXT"
    ], var.type)
    error_message = "resource_aws_route53_record, type must be one of: A, AAAA, CAA, CNAME, DS, HTTPS, MX, NAPTR, NS, PTR, SOA, SPF, SRV, SSHFP, SVCB, TLSA, TXT."
  }
}

variable "ttl" {
  description = "The TTL of the record. Required for non-alias records"
  type        = number
  default     = null
}

variable "records" {
  description = "A string list of records. Required for non-alias records"
  type        = list(string)
  default     = null
}

variable "set_identifier" {
  description = "Unique identifier to differentiate records with routing policies from one another"
  type        = string
  default     = null
}

variable "health_check_id" {
  description = "The health check the record should be associated with"
  type        = string
  default     = null
}

variable "alias" {
  description = "An alias block. Conflicts with ttl & records"
  type = object({
    name                   = string
    zone_id                = string
    evaluate_target_health = bool
  })
  default = null
}

variable "cidr_routing_policy" {
  description = "A block indicating a routing policy based on the IP network ranges of requestors"
  type = object({
    collection_id = string
    location_name = string
  })
  default = null
}

variable "failover_routing_policy" {
  description = "A block indicating the routing behavior when associated health check fails"
  type = object({
    type = string
  })
  default = null
  validation {
    condition     = var.failover_routing_policy == null || contains(["PRIMARY", "SECONDARY"], var.failover_routing_policy.type)
    error_message = "resource_aws_route53_record, failover_routing_policy type must be PRIMARY or SECONDARY."
  }
}

variable "geolocation_routing_policy" {
  description = "A block indicating a routing policy based on the geolocation of the requestor"
  type = object({
    continent   = optional(string)
    country     = optional(string)
    subdivision = optional(string)
  })
  default = null
}

variable "geoproximity_routing_policy" {
  description = "A block indicating a routing policy based on the geoproximity of the requestor"
  type = object({
    aws_region       = optional(string)
    bias             = optional(number)
    local_zone_group = optional(string)
    coordinates = optional(object({
      latitude  = string
      longitude = string
    }))
  })
  default = null
  validation {
    condition     = var.geoproximity_routing_policy == null || var.geoproximity_routing_policy.bias == null || (var.geoproximity_routing_policy.bias >= -90 && var.geoproximity_routing_policy.bias <= 90)
    error_message = "resource_aws_route53_record, geoproximity_routing_policy bias must be between -90 and 90."
  }
}

variable "latency_routing_policy" {
  description = "A block indicating a routing policy based on the latency between the requestor and an AWS region"
  type = object({
    region = string
  })
  default = null
}

variable "multivalue_answer_routing_policy" {
  description = "Set to true to indicate a multivalue answer routing policy"
  type        = bool
  default     = null
}

variable "weighted_routing_policy" {
  description = "A block indicating a weighted routing policy"
  type = object({
    weight = number
  })
  default = null
}

variable "allow_overwrite" {
  description = "Allow creation of this record in Terraform to overwrite an existing record, if any"
  type        = bool
  default     = false
}

variable "timeouts" {
  description = "Configuration block for timeout values"
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}