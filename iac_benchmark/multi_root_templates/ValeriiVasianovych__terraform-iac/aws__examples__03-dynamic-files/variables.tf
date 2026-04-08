variable "aws_region" {
    description = "Define region"
    type        = string
    default     = "us-east-1"
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
        Project     = "AWS EC2 Ubuntu Instance Creation"
        Environment = "Development"
    }
}

variable "allow_security_groups_ports" {
    description = "The ports to open on the security group"
    type        = list(number)
    default     = [22, 80, 443]
}