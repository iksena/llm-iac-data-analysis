variable "record_type" {
  description = "DNS type of all of the resource record sets that Amazon Route 53 will create based on this traffic policy"
  type        = string
  default     = null
}

variable "start_endpoint" {
  description = "An endpoint to be as the starting point for the traffic policy"
  type        = string
  default     = null
}

variable "start_rule" {
  description = "A rule to be as the starting point for the traffic policy"
  type        = string
  default     = null
}

variable "traffic_policy_version" {
  description = "Version of the traffic policy format"
  type        = string
  default     = null
}

variable "endpoints" {
  description = "Configuration block for the definitions of the endpoints that you want to use in this traffic policy"
  type = list(object({
    id     = string
    type   = optional(string)
    region = optional(string)
    value  = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for endpoint in var.endpoints : endpoint.id != null && endpoint.id != ""
    ])
    error_message = "data_aws_route53_traffic_policy_document, endpoints: All endpoints must have a non-empty id."
  }

  validation {
    condition = alltrue([
      for endpoint in var.endpoints : endpoint.type == null ? true : contains([
        "value", "cloudfront", "elastic-load-balancer", "s3-website",
        "application-load-balancer", "network-load-balancer", "elastic-beanstalk"
      ], endpoint.type)
    ])
    error_message = "data_aws_route53_traffic_policy_document, endpoints: Valid endpoint types are: value, cloudfront, elastic-load-balancer, s3-website, application-load-balancer, network-load-balancer, elastic-beanstalk."
  }
}

variable "rules" {
  description = "Configuration block for definitions of the rules that you want to use in this traffic policy"
  type = list(object({
    id   = string
    type = optional(string)
    primary = optional(object({
      endpoint_reference     = optional(string)
      evaluate_target_health = optional(bool)
      health_check           = optional(string)
      rule_reference         = optional(string)
    }))
    secondary = optional(object({
      endpoint_reference     = optional(string)
      evaluate_target_health = optional(bool)
      health_check           = optional(string)
      rule_reference         = optional(string)
    }))
    locations = optional(list(object({
      continent              = optional(string)
      country                = optional(string)
      endpoint_reference     = optional(string)
      evaluate_target_health = optional(bool)
      health_check           = optional(string)
      is_default             = optional(bool)
      rule_reference         = optional(string)
      subdivision            = optional(string)
    })))
    geo_proximity_locations = optional(list(object({
      bias                   = optional(number)
      endpoint_reference     = optional(string)
      evaluate_target_health = optional(bool)
      health_check           = optional(string)
      latitude               = optional(number)
      longitude              = optional(number)
      region                 = optional(string)
      rule_reference         = optional(string)
    })))
    regions = optional(list(object({
      endpoint_reference     = optional(string)
      evaluate_target_health = optional(bool)
      health_check           = optional(string)
      region                 = optional(string)
      rule_reference         = optional(string)
    })))
    items = optional(list(object({
      endpoint_reference = optional(string)
      health_check       = optional(string)
    })))
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.rules : rule.id != null && rule.id != ""
    ])
    error_message = "data_aws_route53_traffic_policy_document, rules: All rules must have a non-empty id."
  }

  validation {
    condition = alltrue([
      for rule in var.rules :
      rule.primary != null && rule.secondary != null ? rule.type == "failover" : true
    ])
    error_message = "data_aws_route53_traffic_policy_document, rules: Primary and secondary blocks are only valid for failover type rules."
  }

  validation {
    condition = alltrue([
      for rule in var.rules :
      rule.locations != null ? rule.type == "geo" : true
    ])
    error_message = "data_aws_route53_traffic_policy_document, rules: Location blocks are only valid for geo type rules."
  }

  validation {
    condition = alltrue([
      for rule in var.rules :
      rule.geo_proximity_locations != null ? rule.type == "geoproximity" : true
    ])
    error_message = "data_aws_route53_traffic_policy_document, rules: Geo proximity location blocks are only valid for geoproximity type rules."
  }

  validation {
    condition = alltrue([
      for rule in var.rules :
      rule.regions != null ? rule.type == "latency" : true
    ])
    error_message = "data_aws_route53_traffic_policy_document, rules: Regions blocks are only valid for latency type rules."
  }

  validation {
    condition = alltrue([
      for rule in var.rules :
      rule.items != null ? rule.type == "multivalue" : true
    ])
    error_message = "data_aws_route53_traffic_policy_document, rules: Items blocks are only valid for multivalue type rules."
  }

  validation {
    condition = alltrue(flatten([
      for rule in var.rules : rule.geo_proximity_locations != null ? [
        for geo_loc in rule.geo_proximity_locations :
        geo_loc.latitude != null ? geo_loc.latitude >= -90 && geo_loc.latitude <= 90 : true
      ] : [true]
    ]))
    error_message = "data_aws_route53_traffic_policy_document, rules: Latitude values must be between -90 and 90 degrees."
  }

  validation {
    condition = alltrue(flatten([
      for rule in var.rules : rule.geo_proximity_locations != null ? [
        for geo_loc in rule.geo_proximity_locations :
        geo_loc.longitude != null ? geo_loc.longitude >= -180 && geo_loc.longitude <= 180 : true
      ] : [true]
    ]))
    error_message = "data_aws_route53_traffic_policy_document, rules: Longitude values must be between -180 and 180 degrees."
  }
}