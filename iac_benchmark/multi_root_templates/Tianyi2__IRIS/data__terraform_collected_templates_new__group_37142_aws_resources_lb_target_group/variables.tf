variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "connection_termination" {
  description = "Whether to terminate connections at the end of the deregistration timeout on Network Load Balancers"
  type        = bool
  default     = false
}

variable "deregistration_delay" {
  description = "Amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds"
  type        = number
  default     = 300

  validation {
    condition     = var.deregistration_delay >= 0 && var.deregistration_delay <= 3600
    error_message = "resource_aws_lb_target_group, deregistration_delay must be between 0 and 3600 seconds."
  }
}

variable "health_check" {
  description = "Health Check configuration block"
  type = object({
    enabled             = optional(bool, true)
    healthy_threshold   = optional(number, 3)
    interval            = optional(number, 30)
    matcher             = optional(string)
    path                = optional(string)
    port                = optional(string, "traffic-port")
    protocol            = optional(string, "HTTP")
    timeout             = optional(number)
    unhealthy_threshold = optional(number, 3)
  })
  default = null

  validation {
    condition = var.health_check == null || (
      var.health_check.healthy_threshold >= 2 && var.health_check.healthy_threshold <= 10
    )
    error_message = "resource_aws_lb_target_group, health_check.healthy_threshold must be between 2 and 10."
  }

  validation {
    condition = var.health_check == null || (
      var.health_check.interval >= 5 && var.health_check.interval <= 300
    )
    error_message = "resource_aws_lb_target_group, health_check.interval must be between 5 and 300 seconds."
  }

  validation {
    condition = var.health_check == null || var.health_check.port == "traffic-port" || (
      can(tonumber(var.health_check.port)) && tonumber(var.health_check.port) >= 1 && tonumber(var.health_check.port) <= 65536
    )
    error_message = "resource_aws_lb_target_group, health_check.port must be 'traffic-port' or a valid port number between 1 and 65536."
  }

  validation {
    condition     = var.health_check == null || contains(["TCP", "HTTP", "HTTPS"], var.health_check.protocol)
    error_message = "resource_aws_lb_target_group, health_check.protocol must be one of TCP, HTTP, or HTTPS."
  }

  validation {
    condition = var.health_check == null || var.health_check.timeout == null || (
      var.health_check.timeout >= 2 && var.health_check.timeout <= 120
    )
    error_message = "resource_aws_lb_target_group, health_check.timeout must be between 2 and 120 seconds."
  }

  validation {
    condition = var.health_check == null || (
      var.health_check.unhealthy_threshold >= 2 && var.health_check.unhealthy_threshold <= 10
    )
    error_message = "resource_aws_lb_target_group, health_check.unhealthy_threshold must be between 2 and 10."
  }
}

variable "lambda_multi_value_headers_enabled" {
  description = "Whether the request and response headers exchanged between the load balancer and the Lambda function include arrays of values or strings. Only applies when target_type is lambda"
  type        = bool
  default     = false
}

variable "load_balancing_algorithm_type" {
  description = "Determines how the load balancer selects targets when routing requests. Only applicable for Application Load Balancer Target Groups"
  type        = string
  default     = "round_robin"

  validation {
    condition     = contains(["round_robin", "least_outstanding_requests", "weighted_random"], var.load_balancing_algorithm_type)
    error_message = "resource_aws_lb_target_group, load_balancing_algorithm_type must be one of round_robin, least_outstanding_requests, or weighted_random."
  }
}

variable "load_balancing_anomaly_mitigation" {
  description = "Determines whether to enable target anomaly mitigation. Target anomaly mitigation is only supported by the weighted_random load balancing algorithm type"
  type        = string
  default     = "off"

  validation {
    condition     = contains(["on", "off"], var.load_balancing_anomaly_mitigation)
    error_message = "resource_aws_lb_target_group, load_balancing_anomaly_mitigation must be 'on' or 'off'."
  }
}

variable "load_balancing_cross_zone_enabled" {
  description = "Indicates whether cross zone load balancing is enabled"
  type        = string
  default     = "use_load_balancer_configuration"

  validation {
    condition     = contains(["true", "false", "use_load_balancer_configuration"], var.load_balancing_cross_zone_enabled)
    error_message = "resource_aws_lb_target_group, load_balancing_cross_zone_enabled must be 'true', 'false', or 'use_load_balancer_configuration'."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name. Cannot be longer than 6 characters"
  type        = string
  default     = null

  validation {
    condition     = var.name_prefix == null || length(var.name_prefix) <= 6
    error_message = "resource_aws_lb_target_group, name_prefix cannot be longer than 6 characters."
  }
}

variable "name" {
  description = "Name of the target group. If omitted, Terraform will assign a random, unique name. This name must be unique per region per account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen"
  type        = string
  default     = null

  validation {
    condition = var.name == null || (
      length(var.name) <= 32 &&
      can(regex("^[a-zA-Z0-9-]+$", var.name)) &&
      !can(regex("^-", var.name)) &&
      !can(regex("-$", var.name))
    )
    error_message = "resource_aws_lb_target_group, name must be maximum 32 characters, contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen."
  }
}

variable "port" {
  description = "Port on which targets receive traffic, unless overridden when registering a specific target. Required when target_type is instance, ip or alb. Does not apply when target_type is lambda"
  type        = number
  default     = null

  validation {
    condition     = var.port == null || (var.port >= 1 && var.port <= 65535)
    error_message = "resource_aws_lb_target_group, port must be between 1 and 65535."
  }
}

variable "preserve_client_ip" {
  description = "Whether client IP preservation is enabled"
  type        = bool
  default     = null
}

variable "protocol_version" {
  description = "Only applicable when protocol is HTTP or HTTPS. The protocol version. Specify GRPC to send requests to targets using gRPC. Specify HTTP2 to send requests to targets using HTTP/2. The default is HTTP1, which sends requests to targets using HTTP/1.1"
  type        = string
  default     = "HTTP1"

  validation {
    condition     = contains(["HTTP1", "HTTP2", "GRPC"], var.protocol_version)
    error_message = "resource_aws_lb_target_group, protocol_version must be one of HTTP1, HTTP2, or GRPC."
  }
}

variable "protocol" {
  description = "Protocol to use for routing traffic to the targets. Should be one of GENEVE, HTTP, HTTPS, TCP, TCP_UDP, TLS, or UDP. Required when target_type is instance, ip, or alb. Does not apply when target_type is lambda"
  type        = string
  default     = null

  validation {
    condition     = var.protocol == null || contains(["GENEVE", "HTTP", "HTTPS", "TCP", "TCP_UDP", "TLS", "UDP"], var.protocol)
    error_message = "resource_aws_lb_target_group, protocol must be one of GENEVE, HTTP, HTTPS, TCP, TCP_UDP, TLS, or UDP."
  }
}

variable "proxy_protocol_v2" {
  description = "Whether to enable support for proxy protocol v2 on Network Load Balancers"
  type        = bool
  default     = false
}

variable "slow_start" {
  description = "Amount time for targets to warm up before the load balancer sends them a full share of requests. The range is 30-900 seconds or 0 to disable"
  type        = number
  default     = 0

  validation {
    condition     = var.slow_start == 0 || (var.slow_start >= 30 && var.slow_start <= 900)
    error_message = "resource_aws_lb_target_group, slow_start must be 0 to disable or between 30 and 900 seconds."
  }
}

variable "stickiness" {
  description = "Stickiness configuration block"
  type = object({
    cookie_duration = optional(number, 86400)
    cookie_name     = optional(string)
    enabled         = optional(bool, true)
    type            = string
  })
  default = null

  validation {
    condition = var.stickiness == null || (
      var.stickiness.cookie_duration >= 1 && var.stickiness.cookie_duration <= 604800
    )
    error_message = "resource_aws_lb_target_group, stickiness.cookie_duration must be between 1 second and 1 week (604800 seconds)."
  }

  validation {
    condition     = var.stickiness == null || contains(["lb_cookie", "app_cookie", "source_ip", "source_ip_dest_ip", "source_ip_dest_ip_proto"], var.stickiness.type)
    error_message = "resource_aws_lb_target_group, stickiness.type must be one of lb_cookie, app_cookie, source_ip, source_ip_dest_ip, or source_ip_dest_ip_proto."
  }

  validation {
    condition = var.stickiness == null || var.stickiness.cookie_name == null || (
      !can(regex("^(AWSALB|AWSALBAPP|AWSALBTG)", var.stickiness.cookie_name))
    )
    error_message = "resource_aws_lb_target_group, stickiness.cookie_name cannot use reserved prefixes AWSALB, AWSALBAPP, or AWSALBTG."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "target_failover" {
  description = "Target failover block. Only applicable for Gateway Load Balancer target groups"
  type = object({
    on_deregistration = optional(string, "no_rebalance")
    on_unhealthy      = optional(string, "no_rebalance")
  })
  default = null

  validation {
    condition     = var.target_failover == null || contains(["rebalance", "no_rebalance"], var.target_failover.on_deregistration)
    error_message = "resource_aws_lb_target_group, target_failover.on_deregistration must be 'rebalance' or 'no_rebalance'."
  }

  validation {
    condition     = var.target_failover == null || contains(["rebalance", "no_rebalance"], var.target_failover.on_unhealthy)
    error_message = "resource_aws_lb_target_group, target_failover.on_unhealthy must be 'rebalance' or 'no_rebalance'."
  }

  validation {
    condition     = var.target_failover == null || var.target_failover.on_deregistration == var.target_failover.on_unhealthy
    error_message = "resource_aws_lb_target_group, target_failover.on_deregistration and target_failover.on_unhealthy must have the same value."
  }
}

variable "target_health_state" {
  description = "Target health state block. Only applicable for Network Load Balancer target groups when protocol is TCP or TLS"
  type = object({
    enable_unhealthy_connection_termination = optional(bool, true)
    unhealthy_draining_interval             = optional(number, 0)
  })
  default = null

  validation {
    condition = var.target_health_state == null || (
      var.target_health_state.unhealthy_draining_interval >= 0 && var.target_health_state.unhealthy_draining_interval <= 360000
    )
    error_message = "resource_aws_lb_target_group, target_health_state.unhealthy_draining_interval must be between 0 and 360000."
  }
}

variable "target_group_health" {
  description = "Target health requirements block"
  type = object({
    dns_failover = optional(object({
      minimum_healthy_targets_count      = optional(string, "off")
      minimum_healthy_targets_percentage = optional(string, "off")
    }))
    unhealthy_state_routing = optional(object({
      minimum_healthy_targets_count      = optional(number, 1)
      minimum_healthy_targets_percentage = optional(string, "off")
    }))
  })
  default = null

  validation {
    condition = var.target_group_health == null || var.target_group_health.dns_failover == null || (
      var.target_group_health.dns_failover.minimum_healthy_targets_percentage == "off" ||
      (can(tonumber(var.target_group_health.dns_failover.minimum_healthy_targets_percentage)) &&
        tonumber(var.target_group_health.dns_failover.minimum_healthy_targets_percentage) >= 1 &&
      tonumber(var.target_group_health.dns_failover.minimum_healthy_targets_percentage) <= 100)
    )
    error_message = "resource_aws_lb_target_group, target_group_health.dns_failover.minimum_healthy_targets_percentage must be 'off' or an integer from 1 to 100."
  }

  validation {
    condition = var.target_group_health == null || var.target_group_health.unhealthy_state_routing == null || (
      var.target_group_health.unhealthy_state_routing.minimum_healthy_targets_percentage == "off" ||
      (can(tonumber(var.target_group_health.unhealthy_state_routing.minimum_healthy_targets_percentage)) &&
        tonumber(var.target_group_health.unhealthy_state_routing.minimum_healthy_targets_percentage) >= 1 &&
      tonumber(var.target_group_health.unhealthy_state_routing.minimum_healthy_targets_percentage) <= 100)
    )
    error_message = "resource_aws_lb_target_group, target_group_health.unhealthy_state_routing.minimum_healthy_targets_percentage must be 'off' or an integer from 1 to 100."
  }
}

variable "target_type" {
  description = "Type of target that you must specify when registering targets with this target group"
  type        = string
  default     = "instance"

  validation {
    condition     = contains(["instance", "ip", "lambda", "alb"], var.target_type)
    error_message = "resource_aws_lb_target_group, target_type must be one of instance, ip, lambda, or alb."
  }
}

variable "ip_address_type" {
  description = "The type of IP addresses used by the target group, only supported when target type is set to ip. Possible values are ipv4 or ipv6"
  type        = string
  default     = null

  validation {
    condition     = var.ip_address_type == null || contains(["ipv4", "ipv6"], var.ip_address_type)
    error_message = "resource_aws_lb_target_group, ip_address_type must be 'ipv4' or 'ipv6'."
  }
}

variable "vpc_id" {
  description = "Identifier of the VPC in which to create the target group. Required when target_type is instance, ip or alb. Does not apply when target_type is lambda"
  type        = string
  default     = null
}