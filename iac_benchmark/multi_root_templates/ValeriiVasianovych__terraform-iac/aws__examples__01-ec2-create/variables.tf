variable "monitoring_value" {
    description = "Enable detailed monitoring"
    type        = bool
    default     = false
}

variable "instance_type" {
    description = "Define instance type"
    type        = string
    default     = "t2.micro"
}

variable "common_tags" {
    description = "Tags to apply to all resources"
    type        = map(string)
    default     = {
        Owner       = "Valerii Vasianovych"
        Project     = "AWS Instance Creation"
        Environment = "Development"
    }
}

variable "allow_security_groups_ports" {
    description = "The ports to open on the security group"
    type        = list(number)
    default     = [22, 80, 443]
}