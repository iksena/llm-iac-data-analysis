variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "access_logs" {
  description = "Access Logs block"
  type = object({
    bucket  = string
    enabled = optional(bool, false)
    prefix  = optional(string, null)
  })
  default = null
}

variable "connection_logs" {
  description = "Connection Logs block. Only valid for Load Balancers of type application"
  type = object({
    bucket  = string
    enabled = optional(bool, false)
    prefix  = optional(string, null)
  })
  default = null
}

variable "client_keep_alive" {
  description = "Client keep alive value in seconds. The valid range is 60-604800 seconds. The default is 3600 seconds"
  type        = number
  default     = 3600
  validation {
    condition     = var.client_keep_alive >= 60 && var.client_keep_alive <= 604800
    error_message = "resource_aws_lb, client_keep_alive must be between 60 and 604800 seconds."
  }
}

variable "customer_owned_ipv4_pool" {
  description = "ID of the customer owned ipv4 pool to use for this load balancer"
  type        = string
  default     = null
}

variable "desync_mitigation_mode" {
  description = "How the load balancer handles requests that might pose a security risk to an application due to HTTP desync"
  type        = string
  default     = "defensive"
  validation {
    condition     = contains(["monitor", "defensive", "strictest"], var.desync_mitigation_mode)
    error_message = "resource_aws_lb, desync_mitigation_mode must be one of: monitor, defensive, strictest."
  }
}

variable "dns_record_client_routing_policy" {
  description = "How traffic is distributed among the load balancer Availability Zones. Only valid for network type load balancers"
  type        = string
  default     = "any_availability_zone"
  validation {
    condition     = contains(["any_availability_zone", "availability_zone_affinity", "partial_availability_zone_affinity"], var.dns_record_client_routing_policy)
    error_message = "resource_aws_lb, dns_record_client_routing_policy must be one of: any_availability_zone, availability_zone_affinity, partial_availability_zone_affinity."
  }
}

variable "drop_invalid_header_fields" {
  description = "Whether HTTP headers with header fields that are not valid are removed by the load balancer (true) or routed to targets (false). Only valid for Load Balancers of type application"
  type        = bool
  default     = false
}

variable "enable_cross_zone_load_balancing" {
  description = "If true, cross-zone load balancing of the load balancer will be enabled"
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API"
  type        = bool
  default     = false
}

variable "enable_http2" {
  description = "Whether HTTP/2 is enabled in application load balancers"
  type        = bool
  default     = true
}

variable "enable_tls_version_and_cipher_suite_headers" {
  description = "Whether the two headers (x-amzn-tls-version and x-amzn-tls-cipher-suite) are added to the client request. Only valid for Load Balancers of type application"
  type        = bool
  default     = false
}

variable "enable_xff_client_port" {
  description = "Whether the X-Forwarded-For header should preserve the source port that the client used to connect to the load balancer in application load balancers"
  type        = bool
  default     = false
}

variable "enable_waf_fail_open" {
  description = "Whether to allow a WAF-enabled load balancer to route requests to targets if it is unable to forward the request to AWS WAF"
  type        = bool
  default     = false
}

variable "enable_zonal_shift" {
  description = "Whether zonal shift is enabled"
  type        = bool
  default     = false
}

variable "enforce_security_group_inbound_rules_on_private_link_traffic" {
  description = "Whether inbound security group rules are enforced for traffic originating from a PrivateLink. Only valid for Load Balancers of type network"
  type        = string
  default     = null
  validation {
    condition     = var.enforce_security_group_inbound_rules_on_private_link_traffic == null || contains(["on", "off"], var.enforce_security_group_inbound_rules_on_private_link_traffic)
    error_message = "resource_aws_lb, enforce_security_group_inbound_rules_on_private_link_traffic must be one of: on, off."
  }
}

variable "idle_timeout" {
  description = "Time in seconds that the connection is allowed to be idle. Only valid for Load Balancers of type application"
  type        = number
  default     = 60
}

variable "internal" {
  description = "If true, the LB will be internal"
  type        = bool
  default     = false
}

variable "ip_address_type" {
  description = "Type of IP addresses used by the subnets for your load balancer"
  type        = string
  default     = "ipv4"
  validation {
    condition     = contains(["ipv4", "dualstack", "dualstack-without-public-ipv4"], var.ip_address_type)
    error_message = "resource_aws_lb, ip_address_type must be one of: ipv4, dualstack, dualstack-without-public-ipv4."
  }
}

variable "ipam_pools" {
  description = "The IPAM pools to use with the load balancer. Only valid for Load Balancers of type application"
  type = object({
    ipv4_ipam_pool_id = string
  })
  default = null
}

variable "load_balancer_type" {
  description = "Type of load balancer to create"
  type        = string
  default     = "application"
  validation {
    condition     = contains(["application", "gateway", "network"], var.load_balancer_type)
    error_message = "resource_aws_lb, load_balancer_type must be one of: application, gateway, network."
  }
}

variable "minimum_load_balancer_capacity" {
  description = "Minimum capacity for a load balancer. Only valid for Load Balancers of type application or network"
  type = object({
    capacity_units = number
  })
  default = null
}

variable "name" {
  description = "Name of the LB. Must be unique within your AWS account, max 32 characters, only alphanumeric characters or hyphens, must not begin or end with a hyphen"
  type        = string
  default     = null
  validation {
    condition     = var.name == null || (length(var.name) <= 32 && can(regex("^[a-zA-Z0-9-]+$", var.name)) && !can(regex("^-", var.name)) && !can(regex("-$", var.name)))
    error_message = "resource_aws_lb, name must be 32 characters or less, contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name"
  type        = string
  default     = null
}

variable "security_groups" {
  description = "List of security group IDs to assign to the LB. Only valid for Load Balancers of type application or network"
  type        = list(string)
  default     = null
}

variable "preserve_host_header" {
  description = "Whether the Application Load Balancer should preserve the Host header in the HTTP request and send it to the target without any change"
  type        = bool
  default     = false
}

variable "secondary_ips_auto_assigned_per_subnet" {
  description = "The number of secondary IP addresses to configure for your load balancer nodes. Only valid for Load Balancers of type network"
  type        = number
  default     = 0
  validation {
    condition     = var.secondary_ips_auto_assigned_per_subnet >= 0 && var.secondary_ips_auto_assigned_per_subnet <= 7
    error_message = "resource_aws_lb, secondary_ips_auto_assigned_per_subnet must be between 0 and 7."
  }
}

variable "subnet_mapping" {
  description = "Subnet mapping block. For Load Balancers of type network subnet mappings can only be added"
  type = list(object({
    subnet_id            = string
    allocation_id        = optional(string, null)
    ipv6_address         = optional(string, null)
    private_ipv4_address = optional(string, null)
  }))
  default = null
}

variable "subnets" {
  description = "List of subnet IDs to attach to the LB. For Load Balancers of type network subnets can only be added"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "xff_header_processing_mode" {
  description = "Determines how the load balancer modifies the X-Forwarded-For header in the HTTP request. Only valid for Load Balancers of type application"
  type        = string
  default     = "append"
  validation {
    condition     = contains(["append", "preserve", "remove"], var.xff_header_processing_mode)
    error_message = "resource_aws_lb, xff_header_processing_mode must be one of: append, preserve, remove."
  }
}