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
output "SecurityGroup_ingress_rules" {
       description = "Shows ingress rules of the Security group "
       value       = formatlist("%s:  %s" ,aws_security_group.terra_sg.ingress[*].description,formatlist("%s , CIDR: %s", aws_security_group.terra_sg.ingress[*].to_port,aws_security_group.terra_sg.ingress[*].cidr_blocks[0]))
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
    description = "SSH ,HTTP, and HTTPS"
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
    
    ingress     = [
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = "Inbound HTTP access "
            from_port        = 80
            protocol         = "tcp"
            to_port          = 80
            prefix_list_ids  = null  # (Optional) List of prefix list IDs.
            ipv6_cidr_blocks = null  # (Optional) List of IPv6 CIDR blocks.
            security_groups  = null   # (Optional) List of security group Group Names if using EC2-Classic, or Group IDs if using a VPC.
            self             = false # (Optional, default false) If true, the security group itself will be added as a source to this ingress rule.
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = "Inbound HTTPS access "
            from_port        = 443
            protocol         = "tcp"
            to_port          = 443
            prefix_list_ids  = null  # (Optional) List of prefix list IDs.
            ipv6_cidr_blocks = null  # (Optional) List of IPv6 CIDR blocks.
            security_groups  = null   # (Optional) List of security group Group Names if using EC2-Classic, or Group IDs if using a VPC.
            self             = false # (Optional, default false) If true, the security group itself will be added as a source to this ingress rule.
            
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = "Inbound SSH access"
            from_port        = 22
            protocol         = "tcp"
            security_groups  = []
            to_port          = 22
             prefix_list_ids  = null  # (Optional) List of prefix list IDs.
            ipv6_cidr_blocks = null  # (Optional) List of IPv6 CIDR blocks.
            security_groups  = null   # (Optional) List of security group Group Names if using EC2-Classic, or Group IDs if using a VPC.
            self             = false # (Optional, default false) If true, the security group itself will be added as a source to this ingress rule.        
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = "Inbound RDP access "
            from_port        = 3389
            protocol         = "tcp"
            to_port          = 3389
            prefix_list_ids  = null  # (Optional) List of prefix list IDs.
            ipv6_cidr_blocks = null  # (Optional) List of IPv6 CIDR blocks.
            security_groups  = null   # (Optional) List of security group Group Names if using EC2-Classic, or Group IDs if using a VPC.
            self             = false # (Optional, default false) If true, the security group itself will be added as a source to this ingress rule.
        },
    ]
    tags = {
    Name = var.sg_name
  }
    timeouts {}
}

