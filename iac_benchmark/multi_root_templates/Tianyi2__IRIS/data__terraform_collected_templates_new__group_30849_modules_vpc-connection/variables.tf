variable "region" {
  description = "(Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region."
  type        = string
  default     = null
  nullable    = true
}

variable "name" {
  description = "(Required) An identifier for the QuickSight VPC connection. This ID is a unique identifier for each AWS Region in an AWS account."
  type        = string
  nullable    = false
}

variable "display_name" {
  description = "(Optional) The display name for the QuickSight VPC connection."
  type        = string
  default     = ""
  nullable    = false
}

variable "default_execution_role" {
  description = <<EOF
  (Optional) A configuration for the default execution role for the QuickSight VPC connection. Use `execution_role` if `default_execution_role.enabled` is `false`. `default_execution_role` as defined below.
    (Optional) `enabled` - Whether to create the default execution role. Defaults to `true`.
    (Optional) `name` - The name of the default execution role. Defaults to `quicksight-vpc-connection-$${var.name}`.
    (Optional) `path` - The path of the default execution role. Defaults to `/`.
    (Optional) `description` - The description of the default execution role.
    (Optional) `policies` - A list of IAM policy ARNs to attach to the default execution role. Defaults to `[]`.
    (Optional) `inline_policies` - A Map of inline IAM policies to attach to the default execution role. (`name` => `policy`).
    (Optional) `permissions_boundary` - The ARN of the IAM policy to use as permissions boundary for the default execution role.
  EOF
  type = object({
    enabled     = optional(bool, true)
    name        = optional(string)
    path        = optional(string, "/")
    description = optional(string, "Managed by Terraform.")

    policies             = optional(list(string), [])
    inline_policies      = optional(map(string), {})
    permissions_boundary = optional(string)
  })
  default  = {}
  nullable = false
}

variable "execution_role" {
  description = <<EOF
  (Optional) The ARN (Amazon Resource Name) of the IAM Role to associate with the QuickSight VPC connection. Only required if `default_execution_role.enabled` is `false`.
  EOF
  type        = string
  default     = null
  nullable    = true
}

variable "subnets" {
  description = "(Required) A list of subnet IDs to associate with the QuickSight VPC connection. At least two subnets are required."
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.subnets) >= 2
    error_message = "At least two subnets are required."
  }
}

variable "default_security_group" {
  description = <<EOF
  (Optional) The configuration of the default security group for the QuickSight VPC connection. `default_security_group` block as defined below.
    (Optional) `enabled` - Whether to use the default security group. Defaults to `true`.
    (Optional) `name` - The name of the default security group. If not provided, the QuickSight VPC connection ID is used for the name of security group.
    (Optional) `description` - The description of the default security group. Defaults to `Managed by Terraform`.
    (Optional) `ingress_rules` - A list of ingress rules in a security group. Defaults to `[]`. Each block of `ingress_rules` as defined below.
      (Optional) `id` - The ID of the ingress rule. This value is only used internally within Terraform code.
      (Optional) `description` - The description of the rule.
      (Required) `protocol` - The protocol to match. Note that if `protocol` is set to `-1`, it translates to all protocols, all port ranges, and `from_port` and `to_port` values should not be defined.
      (Required) `from_port` - The start of port range for the protocols.
      (Required) `to_port` - The end of port range for the protocols.
      (Optional) `ipv4_cidrs` - The IPv4 network ranges to allow, in CIDR notation.
      (Optional) `ipv6_cidrs` - The IPv6 network ranges to allow, in CIDR notation.
      (Optional) `prefix_lists` - The prefix list IDs to allow.
      (Optional) `security_groups` - The source security group IDs to allow.
      (Optional) `self` - Whether the security group itself will be added as a source to this ingress rule.
    (Optional) `egress_rules` - A list of egress rules in a security group. Defaults to `[{ id = "default", protocol = -1, from_port = 1, to_port=65535, ipv4_cidrs = ["0.0.0.0/0"] }]`. Each block of `egress_rules` as defined below.
      (Optional) `id` - The ID of the egress rule. This value is only used internally within Terraform code.
      (Optional) `description` - The description of the rule.
      (Required) `protocol` - The protocol to match. Note that if `protocol` is set to `-1`, it translates to all protocols, all port ranges, and `from_port` and `to_port` values should not be defined.
      (Required) `from_port` - The start of port range for the protocols.
      (Required) `to_port` - The end of port range for the protocols.
      (Optional) `ipv4_cidrs` - The IPv4 network ranges to allow, in CIDR notation.
      (Optional) `ipv6_cidrs` - The IPv6 network ranges to allow, in CIDR notation.
      (Optional) `prefix_lists` - The prefix list IDs to allow.
      (Optional) `security_groups` - The source security group IDs to allow.
      (Optional) `self` - Whether the security group itself will be added as a source to this egress rule.
  EOF
  type = object({
    enabled     = optional(bool, true)
    name        = optional(string)
    description = optional(string, "Managed by Terraform.")
    ingress_rules = optional(
      list(object({
        id              = optional(string)
        description     = optional(string, "Managed by Terraform.")
        protocol        = string
        from_port       = number
        to_port         = number
        ipv4_cidrs      = optional(list(string), [])
        ipv6_cidrs      = optional(list(string), [])
        prefix_lists    = optional(list(string), [])
        security_groups = optional(list(string), [])
        self            = optional(bool, false)
      })),
      []
    )
    egress_rules = optional(
      list(object({
        id              = string
        description     = optional(string, "Managed by Terraform.")
        protocol        = string
        from_port       = number
        to_port         = number
        ipv4_cidrs      = optional(list(string), [])
        ipv6_cidrs      = optional(list(string), [])
        prefix_lists    = optional(list(string), [])
        security_groups = optional(list(string), [])
        self            = optional(bool, false)
      })),
      [{
        id          = "default"
        description = "Allow all outbound traffic."
        protocol    = "-1"
        from_port   = 1
        to_port     = 65535
        ipv4_cidrs  = ["0.0.0.0/0"]
      }]
    )
  })
  default  = {}
  nullable = false
}

variable "security_groups" {
  description = "(Optional) A list of security group IDs to associate with the QuickSight VPC connection."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "dns_resolvers" {
  description = "(Optional) A list of IP addresses of DNS resolver endpoints for the QuickSight VPC connection."
  type        = set(string)
  default     = []
  nullable    = false

  validation {
    condition = alltrue([
      for ip_address in var.dns_resolvers :
      provider::assert::ipv4(ip_address)
    ])
    error_message = "Each value of `dns_resolvers` should be valid IPv4 address."
  }
}

variable "timeouts" {
  description = "(Optional) How long to wait for the QuickSight VPC connection to be created/updated/deleted."
  type = object({
    create = optional(string, "5m")
    update = optional(string, "5m")
    delete = optional(string, "5m")
  })
  default  = {}
  nullable = false
}

variable "tags" {
  description = "(Optional) A map of tags to add to all resources."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "module_tags_enabled" {
  description = "(Optional) Whether to create AWS Resource Tags for the module informations."
  type        = bool
  default     = true
  nullable    = false
}


###################################################
# Resource Group
###################################################

variable "resource_group" {
  description = <<EOF
  (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.
    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.
    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.
    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`.
  EOF
  type = object({
    enabled     = optional(bool, true)
    name        = optional(string, "")
    description = optional(string, "Managed by Terraform.")
  })
  default  = {}
  nullable = false
}
