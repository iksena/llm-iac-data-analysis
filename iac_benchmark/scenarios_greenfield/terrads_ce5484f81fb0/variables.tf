# -----------------------------------------------------------------------------
# MODULE PARAMETERS
#
# These values are expected to be set by the operator when calling the module
# -----------------------------------------------------------------------------


# --------------------------------------------------------------------
# REQUIRED PARAMETERS
#
# These values are required by the module and have no default values
# --------------------------------------------------------------------

variable "vpc_name" {
  default     = "benchmark-vpc"

  type        = string
  description = "The name of the VPC."
}


# --------------------------------------------------------------------
# OPTIONAL PARAMETERS
#
# These values are optional and have default values provided
# --------------------------------------------------------------------

variable "create_private_subnets" {
  type        = bool
  description = "Whether or not to create private subnets."
  default     = true
}

variable "create_public_subnets" {
  type        = bool
  description = "Whether or not to create public subnets."
  default     = true
}

variable "create_nat_gateway" {
  type        = bool
  description = "Whether or not to create a NAT gateway."
  default     = true
}

variable "num_availability_zones" {
  type        = number
  description = "How many AWS Availability Zones (AZs) to use. One subnet of each type (public, private app) will be created in each AZ. Note that this must be less than or equal to the total number of AZs in a region. A value of null means all AZs should be used. For example, if you specify 3 in a region with 5 AZs, subnets will be created in just 3 AZs instead of all 5. Defaults to all AZs in a region."
  default     = null
}
