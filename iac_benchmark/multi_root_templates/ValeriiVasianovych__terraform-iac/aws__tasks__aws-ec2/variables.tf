variable "region" {
    type = string
    description = "The region in which to launch the EC2 instance"
    default = "us-east-1"
}

variable "instance_type" {
    type = string
    description = "The type of instance to launch"
    default = "t2.micro" 
}

variable "key_name" {
    type = string
    description = "The name of the key pair to use for the instance"
    default = "aws_ssh_key"
  
}

variable "common_tags" {
    type = map(string)
    description = "Common tags to apply to all resources"
    default = {
        Owner = "Valerii Vasianovych"
        Project = "Test Project"
    }
}

variable "count_instance" {
    type = number
    description = "The number of instances to launch"
    default = 2
}