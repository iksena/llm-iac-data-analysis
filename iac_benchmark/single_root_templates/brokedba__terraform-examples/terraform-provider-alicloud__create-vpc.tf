# ── variables.tf ────────────────────────────────────
# Aws account region and autehntication 
variable "ali_access_key" {}
variable "ali_secret_key" {}

variable "prefix" {
  description = "The prefix used for the resources group in this example"
  default = "TerraDemo"
}

# Ali Cloud Zone

      variable  "ali_zone" {
        type = map
        default = {
        us-east-1   = "us-east-1b"
        hongkong    = "cn-hongkong-b" # Centos 7
        germany     = "eu-central-1a" #8.8
        UK          = "eu-west-1a"
        us-west-1   = "us-west-1a"  
       }
     } 

variable "ali_region" {
    default = "us-east-1"   # "hongkong" have only # 2C4G free tier 3 months , not 1C1G free tier CPus
}

# VPC INFO
    variable "vpc_name" {
      default = "Terravpc"
    }
    
    variable "vpc_cidr" {
      default = "192.168.0.0/16"
    }

# SUBNET/VSWITCH INFO
    variable "vswitch_name"{
      default = "terrasub" 
      }

    variable "vswitch_cidr"{
      default = "192.168.10.0/24"
      } 
    variable "map_public_ip_on_launch" { 
      description = "Indicate if instances launched into the VPC's Subnet will be assigned a public IP address . "
      default = true   
    }  

# IGW INFO
    variable "igw_name"{
      default = "terra-igw" 
      }

# ROUTE TABLE INFO
    variable "rt_name"{
      default = "terra-rt" 
      }
# ROUTE TABLE INFO
    variable "sg_name"{
      default = "terra-sg" 
      }      




# ── outputs.tf ────────────────────────────────────
data "alicloud_vpcs" "terra_vpcs" {
  ids  =[alicloud_vpc.terra_vpc.id,]
  status     = "Available"
# name_regex = "^foo"
}

data "alicloud_vswitches" "terra_subs" {
  ids               = [alicloud_vswitch.terra_sub.id,]
  # name_regex = "${alicloud_vswitch.terra_subs.vswitch_name}"
}

data "alicloud_security_groups" "terra_sgs" {
  ids             = [alicloud_security_group.terra_sg.id,]
resource_group_id = alicloud_resource_manager_resource_group.rg.id
depends_on =  [ alicloud_security_group.terra_sg ]
}


output  vpc_name {
  description = "Name of created VPC. "
  value = "${data.alicloud_vpcs.terra_vpcs.vpcs.0.vpc_name}"
}

output "vpc_id" {
      description = "ID of created VPC. "
      value       = "${data.alicloud_vpcs.terra_vpcs.vpcs.0.id}"
    }

output "vpc_CIDR" {
      description = "cidr block of created VPC. "
      value       = "${data.alicloud_vpcs.terra_vpcs.vpcs.0.cidr_block}"
    }    
    
output "Subnet_Name" {
      description = "Name of created VPC's Subnet. "
      value       = "${data.alicloud_vswitches.terra_subs.vswitches.0.name}"
    }
 
output "Subnet_CIDR" {
      description = "cidr block of VPC's VSwitch. "
      value       = "${data.alicloud_vswitches.terra_subs.vswitches.0.cidr_block}"
    }



output "vpc_dedicated_security_group_Name" {
       description = "Security Group Name. "
       value       = "${data.alicloud_security_groups.terra_sgs.groups.0.name}"
   }

# Filter the security group rule by group
data "alicloud_security_group_rules" "ingress_rules" {
  group_id    = "${data.alicloud_security_groups.terra_sgs.groups.0.id}" # or ${var.security_group_id}
  nic_type    = "internet"
  direction   = "ingress"
  ip_protocol = "tcp"
  depends_on = [ alicloud_security_group.terra_sg ]
}

output "vpc_dedicated_security_ingress_rules" {
       description = "Shows ingress rules of the Security group "
       value       = formatlist("%s:  %s" ,data.alicloud_security_group_rules.ingress_rules.rules.*.description,formatlist("%s , CIDR: %s", data.alicloud_security_group_rules.ingress_rules.rules.*.port_range,data.alicloud_security_group_rules.ingress_rules.rules.*.source_cidr_ip))
   }      


  






# ── vpc.tf ────────────────────────────────────
 terraform {
 # required_version =  OpenTofu # The latest HashiCorp terraform release under MPL is 1.5.5
 required_providers {
    alicloud = {
      source = "aliyun/alicloud"
      version = "1.211.2"
    }
  }
    }
# Provider specific configs
provider "alicloud" {
  access_key = var.ali_access_key
  secret_key = var.ali_secret_key
  region     = var.ali_region
}

#################
# Resorce Group
#################
# alicloud Resource group
resource "alicloud_resource_manager_resource_group"  "rg" {
  resource_group_name     = "${var.prefix}-rg"
  display_name            = "${var.prefix}-rg"
}

#################
# VPC
#################
resource "alicloud_vpc" "terra_vpc" {
    vpc_name          = var.vpc_name
    cidr_block        = var.vpc_cidr
    resource_group_id = alicloud_resource_manager_resource_group.rg.id
    }

#################
# VSWITCH
#################
# ali_vswitch.terra_sub:
resource "alicloud_vswitch" "terra_sub" {
    vpc_id                          = alicloud_vpc.terra_vpc.id
    zone_id                         = var.ali_zone[var.ali_region]
    cidr_block                      = var.vswitch_cidr
    vswitch_name                    = var.vswitch_name
    }

######################
# Security Group
######################    
# ali_security_group.terra_sg:
resource "alicloud_security_group" "terra_sg" {
  name              = var.sg_name
  description       = "Terra security group"
  vpc_id            = alicloud_vpc.terra_vpc.id
  resource_group_id = alicloud_resource_manager_resource_group.rg.id
}

resource "alicloud_security_group_rule" "allow_http_80" {
  type              = "ingress"
  ip_protocol       = "tcp"
  description       = "allow_http_80"
  #nic_type          = "internet"  # var.nic_type
  policy            = "accept"
  port_range        = "80/80"
  priority          = 1
  security_group_id = alicloud_security_group.terra_sg.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_https_443" {
  type              = "ingress"
  ip_protocol       = "tcp"
  description       = "allow_https_443"
  #nic_type          = "internet" #var.nic_type
  policy            = "accept"
  port_range        = "443/443"
  priority          = 1
  security_group_id = alicloud_security_group.terra_sg.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_https_22" {
  type              = "ingress"
  ip_protocol       = "tcp"
  description       = "allow_https_22"
  #nic_type          = "internet" # var.nic_type
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.terra_sg.id
  cidr_ip           = "0.0.0.0/0"
}

################################################
#  Internet Gateway desn't exist in alicloud
############################################### 
###############################
# Route Table isn't necessary
############################### 
/*  ali_route_table.terra_rt:
resource "alicloud_route_table" "terra_rt" {
  description      = "test-description"
  vpc_id           = alicloud_vpc.defaultVpc.id
  route_table_name = var.name
  associate_type   = "VSwitch"
}
# add route rules
resource "alicloud_route_entry" "foo" {
  route_table_id        = alicloud_vpc.foo.route_table_id
  destination_cidrblock = "172.11.1.1/32"
  nexthop_type          = "Instance"
  nexthop_id            = alicloud_instance.foo.id
}
# ali_route_table_association.terra_rt_sub:
resource "alicloud_route_table_attachment" "foo" {
  vswitch_id     = alicloud_vswitch.terra_sub.id
  route_table_id = alicloud_route_table.terra_rt.id
}
*/