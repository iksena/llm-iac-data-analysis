variable "access_key" {
     description = "Access key to AWS console"
     default     = "unused"
}
variable "secret_key" {
     description = "Secret key to AWS console"
     default     = "unused"
}




variable "number_of_instances" {
        description = "number of instances to be created"
        default = 3
}



variable "region" {
  default     = "us-east-1"
  type        = string
  description = "Region of the VPC"
}


variable "cidr_block" {
  default     = "10.0.0.0/16"
  type        = string
  description = "CIDR block for the VPC"

}

variable "instance_name" {
        description = "Name of the instance to be created"
        default = "test"
}

variable "instance_type" {
        default = "t2.micro"
}

variable "vol_size" {
        description = " instance volume size"
        default = 20
}


variable "private_subnet_cidr_blocks" {
  default     = ["10.0.1.0/24","10.0.2.0/24", "10.0.3.0/24"]
  type        = list
  description = "List of private subnet CIDR blocks"
}

variable "availability_zones" {
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  type        = list
  description = "List of availability zones"
}





# variable "public_subnet_cidr_blocks" {
#  default     = ["10.0.0.0/24", "10.0.2.0/24"]
#  type        = list
#  description = "List of public subnet CIDR blocks"
#}


################################### Instance name and type


variable "subnet_id" {
        description = "The VPC subnet the instance(s) will be created in"
        #default = "subnet-a5a72ce8"
        default = "subnet-042c1134454f1a2f2"


}


variable "ami_id" {
        description = "The AMI to use"
        default = "ami-0c293f3f676ec4f90"
}






##########################################################

 
