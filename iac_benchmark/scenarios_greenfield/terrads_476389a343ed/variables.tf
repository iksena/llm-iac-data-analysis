# https://www.terraform.io/docs/configuration/variables.html
# https://www.terraform.io/docs/configuration/types.html

# ======================================== Credentials ========================================

variable "access_key" {
  type        = string
  description = "The AWS Access Key ID."
}

variable "secret_key" {
  type        = string
  description = "The AWS Secret Access Key."
}

variable "region" {
  type        = string
  description = "The AWS Region for deployment."
}

# ======================================== Metadata ========================================

variable "environment" {
  type        = string
  description = "The name of environment for deployment."
}

variable "uuid" {
  type        = string
  description = "A unique identifier for the deployment."
}

variable "owner" {
  type        = string
  description = "An identifiable name, username, or ID that owns the deployment."
}

variable "git_url" {
  type        = string
  description = "The URL for the git repository."
  default     = "https://github.com/moorara/kops-aws"
}

variable "git_branch" {
  type        = string
  description = "The name of the git branch."
}

variable "git_commit" {
  type        = string
  description = "The short or long hash of the git commit."
}

# ======================================== Configurations ========================================

variable "domain" {
  type        = string
  description = "A full domain name for the deployment."
}

variable "keybase_username" {
  type        = string
  description = "A keybase username for encrypting the kops user AWS Secret Access Key."
}

variable "az_count" {
  type        = number
  description = "The total number of availability zones required."
  default     = 99  // This is a hack to default to all availability zones
}

variable "create_subnets" {
  type        = bool
  description = "Whether or not to create private and public subnets with gateways."
  default     = false
}

variable "enable_vpc_logs" {
  type        = bool
  description = "Whether or not to enable VPC flow logs."
  default     = false
}

# https://en.wikipedia.org/wiki/Classful_network
# https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing
variable "vpc_cidrs" {
  type        = map(string)
  description = "VPC CIDR for each AWS Region."
  default = {
    ap-northeast-1 = "10.10.0.0/16",
    ap-northeast-2 = "10.11.0.0/16",
    ap-south-1     = "10.12.0.0/16",
    ap-southeast-1 = "10.13.0.0/16",
    ap-southeast-2 = "10.14.0.0/16",
    ca-central-1   = "10.15.0.0/16",
    eu-central-1   = "10.16.0.0/16",
    eu-north-1     = "10.17.0.0/16",
    eu-west-1      = "10.18.0.0/16",
    eu-west-2      = "10.19.0.0/16",
    eu-west-3      = "10.20.0.0/16",
    sa-east-1      = "10.21.0.0/16",
    us-east-1      = "10.22.0.0/16",
    us-east-2      = "10.23.0.0/16",
    us-west-1      = "10.24.0.0/16",
    us-west-2      = "10.25.0.0/16"
  }
}
