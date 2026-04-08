########################
#    Resource Naming   #
########################
variable "name" {
  description = "The base name of the resources"
  type        = string
}

############################
# Web Application Firewall #
############################
variable "scope" {
  description = "The scope of the Web ACL. Must be one of 'REGIONAL' or 'CLOUDFRONT'."
  type        = string
  default     = "REGIONAL"
}

variable "waf_description" {
  description = "The description of the Web Application Firewall."
  type        = string
  default     = "WAF for API Gateway"
}

variable "sampled_requests_enabled" {
  description = "Indicates whether sampled requests are enabled."
  type        = bool
  default     = false
}

##########################
# WAF Association to API #
##########################
variable "association_resource_arns" {
  description = "A list of ARNs of the resources to associate with the WebACL."
  type        = list(string)
  default     = []
}

##########################
#       Logging          #
##########################
variable "retention_in_days" {
  description = "The number of days to retain CloudWatch logs."
  type        = number
  default     = 30
}

variable "aws_region" {
  description = "The AWS region."
  type        = string
}

########################
#      Tags Config     #
########################
variable "tags" {
  description = "Tags to assign"
  type        = map(string)
}