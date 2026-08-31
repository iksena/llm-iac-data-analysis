#This Section has all the Modules Variables
variable "cluster-name" { default = "benchmark-eks" }
variable "cidr-block" { default = "10.0.0.0/16" }
variable "vpc-name" { default = "benchmark-vpc" }
variable "env" { default = "dev" }
variable "igw-name" { default = "benchmark-igw" }
variable "pub-subnet-count" { default = 3 }
variable "pub-cidr-block" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}
variable "pub-availability-zone" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
variable "pub-sub-name" { default = "benchmark-public-subnet" }
variable "pri-subnet-count" { default = 3 }
variable "pri-cidr-block" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
}
variable "pri-availability-zone" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
variable "pri-sub-name" { default = "benchmark-private-subnet" }
variable "public-rt-name" { default = "benchmark-public-rt" }
variable "private-rt-name" { default = "benchmark-private-rt" }
variable "eip-name" { default = "benchmark-eip" }
variable "ngw-name" { default = "benchmark-ngw" }
variable "eks-sg" { default = "benchmark-eks-sg" }

#IAM
variable "is_eks_role_enabled" {
  type    = bool
  default = true
}
variable "is_eks_nodegroup_role_enabled" {
  type    = bool
  default = true
}

# EKS
variable "is-eks-cluster-enabled" { default = true }
variable "cluster-version" { default = "1.30" }
variable "endpoint-private-access" { default = true }
variable "endpoint-public-access" { default = true }
variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))
  default = []
}
variable "ondemand_instance_types" { default = ["t3.medium"] }
variable "spot_instance_types" { default = ["t3.medium"] }
variable "desired_capacity_on_demand" { default = 2 }
variable "min_capacity_on_demand" { default = 1 }
variable "max_capacity_on_demand" { default = 3 }
variable "desired_capacity_spot" { default = 0 }
variable "min_capacity_spot" { default = 0 }
variable "max_capacity_spot" { default = 2 }
