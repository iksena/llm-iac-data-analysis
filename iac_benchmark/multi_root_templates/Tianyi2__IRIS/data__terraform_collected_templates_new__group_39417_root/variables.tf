variable "public_subnets" {
  type        = list(string)
  description = "Network ranges for public subnets created in the VPC. Able to access the internet through Default Internet gateway."
  default     = ["10.101.0.0/16"]
}

variable "private_subnets" {
  type        = list(string)
  description = "Network ranges for private subnets created in the VPC. Able to access the internet through Cloud Router and NAT Gateway."
  default     = ["10.102.0.0/16"]
}

variable "connector_subnet" {
  type        = string
  default     = "10.128.0.0/28"
  description = "Network range for the connector subnet created in the VPC. This subnet is used for private access to GCP-managed services like CloudSQL."
}

variable "internal_subdomain" {
  type        = string
  default     = ""
  description = <<EOF
When specified, creates a private Google Cloud DNS zone that allows internal DNS resolution within the VPC.
EOF
}

variable "vpc_flow_logs" {
  type = object({
    enabled              = bool
    aggregation_interval = string
    flow_sampling        = number
    metadata             = string
  })

  default = {
    enabled              = false
    aggregation_interval = "INTERVAL_5_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }

  description = <<EOF
When specified, enables VPC Flow Logs in all created subnets.
The defaults are set to a balance of forensic value and incurred costs.
The drivers of these costs (in order) are: traffic volume, flow_sampling, aggregation_interval, metadata inclusion.
EOF
}

locals {
  vpc_flow_logs_settings = var.vpc_flow_logs.enabled ? toset([var.vpc_flow_logs]) : []
}
