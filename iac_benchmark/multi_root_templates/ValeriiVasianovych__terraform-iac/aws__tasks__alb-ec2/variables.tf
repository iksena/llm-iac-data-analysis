variable "region" {
    type = string
    description = "The region in which to launch the EC2 instance"
    default = "us-east-1"
}

variable "instance_count" {
    description = "Number of EC2 instances to create"
    type        = number
    default     = 2
}

variable "instance_type" {
    description = "EC2 instance type"
    type        = string
    default     = "t2.micro"
}

variable "env" {
    description = "Environment name"
    type        = string
    default     = "dev"
}

variable "key_name" {
    type = string
    description = "The name of the key pair to use for the instance"
    default = "aws_ssh_key"
}

variable "count_instance" {
    type = number
    description = "The number of instances to launch"
    default = 1
}