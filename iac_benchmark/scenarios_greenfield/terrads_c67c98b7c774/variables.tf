
#####EC2#####
variable "ec2_instance_image" {
      type = string
      description = "Instance image id. eg. ami-xxxx"
      default = ""
}

variable "ec2_instance_type" {
  type    = string
  default = "t3.medium"
  description = "EC2 Instance type for Sonar instance"
}
variable "ec2_instance_count" {
  type    = string
  default = "1"
  description = "EC2 Instance type for Sonar instance"
}
#####GLOBAL#####
variable "environment" {
      type = string
      description = "acronym to designate the stage of the environment. E.g. dev, int, prd, ...)"
      default = "dev"
}
variable "project_name" {
      type = string
      description = "input project name"
      default = "benchmark-project"
}
variable "volume_size" {
      type = string
      description = "input project name)"
      default = "20"
}

variable "terraform_bucket" {
      type = string
      description = "name of terraform bucket"
      default = "benchmark-terraform-bucket"
}
variable "standard_tags" {
  type =  object({
    managed_by                 = string
    warning_description        = string
  })
  description = "List of standard tags for the EC2 instance"
  default = {
    managed_by          = "terraform"
    warning_description = "benchmark scenario"
  }
}
variable "vpc_cidr_block" {
      type = string
      default = "10.0.0.0/16"
      description = "What VPC to be used for the network"
}
variable "public_subnet_a_cidr" {
      type = string
      default = "10.0.1.0/24"
      description = "Public subnet A id"
}
variable "public_subnet_b_cidr" {
      type = string
      default = "10.0.2.0/24"
      description = "Public subnet B id"
}
variable "private_subnet_a_cidr" {
      type = string
      default = "10.0.11.0/24"
      description = "Private subnet A id"
}
variable "private_subnet_b_cidr" {
      type = string
      default = "10.0.12.0/24"
      description = "Private subnet A id"
}
