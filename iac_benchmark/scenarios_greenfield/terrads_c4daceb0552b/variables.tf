// configuration
variable has_private_subnet {default = true}
variable has_nat_gateway {default = false}
variable has_nat_instance {default = false}
variable has_egress_only_internet_gateway {default = false}

// tags
variable name {default = "benchmark-vpc"}
//VPC
variable region {default = "us-east-1"}
variable cidr_block {default = "10.0.0.0/16"}
variable assign_generated_ipv6  { default = false}
variable tenancy  { default = "default"} // default | dedicated
variable tags {
  default = {
    Created = "terraform"
  }
}

//subnets
variable cidr_subnets {default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]} // list with only 4 subnets
variable region_az {default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]} // list with only two AZ
variable enable_dns_support {default = false}
variable enable_dns_hostnames {default = false}
variable public_subnet_map_public_ip_on_launch {default = false} // Only for public subnets
