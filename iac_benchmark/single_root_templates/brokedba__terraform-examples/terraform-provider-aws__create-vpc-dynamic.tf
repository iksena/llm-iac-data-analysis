# ── variables.tf ────────────────────────────────────
# Aws account region and autehntication 
#variable "aws_access_key" {}
#variable "aws_secret_key" {}
variable "aws_region" {
    default = "us-east-1"
}
# VPC INFO
    variable "vpc_name" {
      default = "Terravpc"
    }
    
    variable "vpc_cidr" {
      default = "192.168.0.0/16"
    }

# SUBNET INFO
    variable "subnet_name"{
      default = "terrasub" 
      }

    variable "subnet_cidr"{
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

# SG rules


variable "main_sg" {
default = {
sg_ssh = {
        SSH = 22
        },
sg_web = {
        SSH = 22
        HTTP = 80
        HTTPS= 443
            },
sg_win = {
        RDP = 3389
        HTTP = 80
        HTTPS= 443
        }
}
}
 

  variable "sg_type"{
      default = "WEB" 
      }

 
     


# ── outputs.tf ────────────────────────────────────
output "vpc_Name" {
      description = "Name of created VPC. "
      value       = "${lookup(aws_vpc.terra_vpc.tags, "Name")}"
    }
output "vpc_id" {
      description = "id of created VPC. "
      value       = aws_vpc.terra_vpc.id
    }
output "vpc_CIDR" {
      description = "cidr block of created VPC. "
      value       = aws_vpc.terra_vpc.cidr_block
    }    
    
output "Subnet_Name" {
      description = "Name of created VPC's Subnet. "
      value       = "${lookup(aws_subnet.terra_sub.tags, "Name")}"
    }
output "Subnet_id" {
      description = "id of created VPC. "
      value       = aws_subnet.terra_sub.id
    }
output "Subnet_CIDR" {
      description = "cidr block of VPC's Subnet. "
      value       = aws_subnet.terra_sub.cidr_block
    }

output "map_public_ip_on_launch" {
      description = "Indicate if instances launched into the VPC's Subnet will be assigned a public IP address . "
      value       = aws_subnet.terra_sub.map_public_ip_on_launch
    }
  
output "internet_gateway_id" {
       description = "id of internet gateway. "
       value       = aws_internet_gateway.terra_igw.id
    }
output "internet_gateway_Name" {
       description = "Name of internet gateway. "
       value       = "${lookup(aws_internet_gateway.terra_igw.tags, "Name")}"
    }    

output "route_table_id" {
       description = "id of route table. "
       value       = aws_route_table.terra_rt.id
    }
output "route_table_Name" {
       description = "Name of route table. "
       value       = "${lookup(aws_route_table.terra_rt.tags, "Name")}"
    }    
 
output "route_table_routes" {
       description = "A list of routes. "
       value       = aws_route_table.terra_rt.route
    } 

output "vpc_dedicated_security_group_Name" {
       description = "Security Group Name. "
       value       = aws_security_group.terra_sg.name
   }
output "vpc_dedicated_security_group_id" {
       description = "Security group id. "
       value       = aws_security_group.terra_sg.id
   }
output "vpc_dedicated_security_ingress_rules" {
      description = "Shows ingress rules of the Security group "
      #value       = {for k,v in aws_security_group_rule.terra_sg_rule : k => v.to_port}
      value        = { for sg,p in  aws_security_group_rule.terra_sg_rule : sg => format("%s => CIDR %s",p.to_port,p.cidr_blocks[0]) }
}

# ── vpc.tf ────────────────────────────────────
 terraform {
      required_version = ">= 0.12.0"
    }
# Provider specific configs
provider "aws" {
#    access_key = "${var.aws_access_key}"
#    secret_key = "${var.aws_secret_key}"
    region = var.aws_region
}

data "aws_availability_zones" "ad" {
  state = "available"
  filter {
    name   = "region-name"
    values =[var.aws_region]
  }
}    
#################
# VPC
#################
resource "aws_vpc" "terra_vpc" {
    cidr_block                       = var.vpc_cidr
    tags                             = {
        "Name" = var.vpc_name
    }
}
#################
# SUBNET
#################
# aws_subnet.terra_sub:
resource "aws_subnet" "terra_sub" {
    vpc_id                          = aws_vpc.terra_vpc.id
    availability_zone               =  data.aws_availability_zones.ad.names[0]
    cidr_block                      = var.subnet_cidr
    map_public_ip_on_launch         = var.map_public_ip_on_launch
    tags                            = {
        "Name" = var.subnet_name
    }
    

    timeouts {}
}
######################
# Internet Gateway
###################### 
# aws_internet_gateway.terra_igw:
resource "aws_internet_gateway" "terra_igw" {
    vpc_id   = aws_vpc.terra_vpc.id
    tags     = {
        "Name" = var.igw_name
    }
}
######################
# Route Table
###################### 
# aws_route_table.terra_rt:
resource "aws_route_table" "terra_rt" {
    vpc_id  = aws_vpc.terra_vpc.id
    route  {
            cidr_block   = "0.0.0.0/0"
            gateway_id   = aws_internet_gateway.terra_igw.id
        }
    
    tags             = {
        "Name" = var.rt_name
    }

}

# aws_route_table_association.terra_rt_sub:
resource "aws_route_table_association" "terra_rt_sub" {
    route_table_id = aws_route_table.terra_rt.id
    subnet_id      = aws_subnet.terra_sub.id
}

######################
# Security Group
######################    
# aws_security_group.terra_sg:
resource "aws_security_group" "terra_sg" {
    name        = var.sg_name
    vpc_id      = aws_vpc.terra_vpc.id
    description = "${var.sg_type} Based security Group"
    egress {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = "default egress"
            from_port        = 0
            protocol         = "-1"
            to_port          = 0
            self             = false
        }
    tags = {
    Name = var.sg_name
  }
    timeouts {}
}

locals {
 sg_mapping = {           #  variable substitution within a variable
      SSH = var.main_sg.sg_ssh
      WEB = var.main_sg.sg_web
      WIN = var.main_sg.sg_win
}
}

resource "aws_security_group_rule" "terra_sg_rule" {
  for_each = local.sg_mapping[var.sg_type]
  type              = "ingress"
  from_port         = each.value
  to_port           = each.value
  protocol          = "tcp"
  security_group_id = aws_security_group.terra_sg.id
  description = each.key
  cidr_blocks      = ["0.0.0.0/0",]
}                    


