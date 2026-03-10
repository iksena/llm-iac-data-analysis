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

# COMPUTE INSTANCE INFO

      variable "instance_name" {
        default = "TerraCompute"
      }

      variable "preserve_boot_volume" {
        default = false
      }
      variable "boot_volume_size_in_gbs" {
        default = "10"
      }
      variable "instance_type" {
        default = "t2.micro"
      }
      variable "instance_ami_id" {
        type = map

        default = {
        CENTOS8   = "ami-056d1e4814a97ac59"
        CENTOS7   = "ami-0d0db0aecada009c5"
        RHEL8     = "ami-09353c38276693bcb"
        RHEL7     = "ami-01f1bea9a9de3c605"
        UBUNTU    = "ami-0f40c8f97004632f9"
       AMAZON_LINUX  = "ami-0947d2ba12ee1ff75"  # Centos 7
       WINDOWS    = "ami-06f6f33114d2db0b1"
       SUSE       = "ami-08c68a700c45e62fa"
       }
     }  
variable "OS" {
  description = "the selected ami based OS"
  default       = "CENTOS7" 
}

# VNIC INFO
        variable "private_ip" {
        default = "192.168.10.51"
      }
      
# BOOT INFO      
  # user data
      variable "user_data" {
        default = "./cloud-init/vm.cloud-config"
      }     
      #variable "ssh_public_key" {}
      variable "block_storage_size_in_gbs" {
        default = "10"
      }
 # EBS 
      variable "vol_name" {
      type        = string
      default     = "vol_0"
      description = "The name of the EBS"
      }
      variable "ebs_volume_enabled" {
      type        = bool
      default     = true
      description = "Flag to control the ebs creation."
      }     
      variable "ebs_volume_type" {
      type        = string
      default     = "gp2"
      description = "The type of EBS volume. Can be standard, gp2 or io1."
      }
      variable "ebs_iops" {
      type        = number
      default     = 0
      description = "Amount of provisioned IOPS. This must be set with a volume_type of io1."
      }

      variable "ebs_volume_size" {
       type        = number
       default     = 8
       description = "Size of the ebs volume in gigabytes."
      }
      variable "ebs_device_name" {
      type        = list(string)
      default     = ["/dev/xvdb", "/dev/xvdc", "/dev/xvdd", "/dev/xvde", "/dev/xvdf", "/dev/xvdg", "/dev/xvdh", "/dev/xvdi", "/dev/xvdj", "/dev/xvdk", "/dev/xvdl", "/dev/xvdm", "/dev/xvdn", "/dev/xvdo", "/dev/xvdp", "/dev/xvdq", "/dev/xvdr", "/dev/xvds", "/dev/xvdt", "/dev/xvdu", "/dev/xvdv", "/dev/xvdw", "/dev/xvdx", "/dev/xvdy", "/dev/xvdz"]
      description = "Name of the EBS device to mount."
      }

      variable "instance_cpus" {
      default = 1
      }        
#
variable "network_interface" {
  description = "Customize network interfaces to be attached at instance boot time"
  type        = list(map(string))
  default     = []
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
       #value       = formatlist("%s:   %s" ,aws_security_group.terra_sg.ingress[*].description,aws_security_group.terra_sg.ingress[*].to_port)
   }      
    
##  INSTANCE OUTPUT

      output "instance_id" {
        description = " id of created instances. "
        value       = aws_instance.terra_inst.id
      }
      
      output "private_ip" {
        description = "Private IPs of created instances. "
        value       = aws_instance.terra_inst.private_ip
      }
      
      output "public_ip" {
        description = "Public IPs of created instances. "
        value       = aws_instance.terra_inst.public_ip
      }

 output "SSH_Connection" {
     value      = format("ssh connection to instance ${var.instance_name} ==> sudo ssh -i ~/id_rsa_aws centos@%s",aws_instance.terra_inst.public_ip)
}

  
  
    

# ── compute.tf ────────────────────────────────────

      terraform {
        required_version = ">= 0.12.0"
      }
######################
# DATA SOURCE
######################

data "aws_ami" "terra_img" {
   most_recent = true
  owners = ["679593333241"]
  
    filter {
    name = "name"
    values = ["centos-7*"]
  }

  filter {
    name = "state"
    values = ["available"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
    filter {
    name   = "block-device-mapping.volume-size"
    values = ["8"]
  }
}

locals {
  ebs_iops = var.ebs_volume_type == "io1" ? var.ebs_iops : 0
}

# resource "aws_key_pair" "terraform-demo" {
#  key_name   = "var.key_KeyPair"
#  public_key = "${file("/home/brokedba/id_rsa_aws.pub")}"
#}
 #     data  "aws_subnet" "terra_sub" {
    #Required
    #count     = length(data.oci_core_subnet.terrasub.id)
    #subnet_id =lookup(oci_core_subnet.terrasub[count.index],id)
  #  subnet_id =  aws_subnet.terra_sub.id
#}
######################
# INSTANCE
######################
#data "template_file" "user_data" {
#  template = file("../scripts/add-ssh-web-app.yaml")
#}
variable "key_name" { default= "demo_aws_KeyPair"}

resource "aws_key_pair" "terra_key" {
   key_name   = var.key_name
   public_key = file("~/id_rsa_aws.pub")
  }
 resource "aws_instance" "terra_inst" {
    ami                          = data.aws_ami.terra_img.id
    availability_zone            = data.aws_availability_zones.ad.names[0]
    #cpu_core_count               = 1
    #cpu_threads_per_core         = 1
    disable_api_termination      = false
    ebs_optimized                = false
    get_password_data            = false
    hibernation                  = false
    instance_type                = var.instance_type
    private_ip                   = var.private_ip
    associate_public_ip_address  = var.map_public_ip_on_launch
    key_name                     = aws_key_pair.terra_key.key_name
    #key_name = var.key_name
    monitoring                   = false
    secondary_private_ips        = []
    security_groups              = []
    source_dest_check            = true
    subnet_id                    = aws_subnet.terra_sub.id
    user_data                    = filebase64(var.user_data)
    #user_data = filebase64("${path.module}/example.sh") 
    # user_data                   = "${file(var.user_data)}"
    # user_data_base64            = var.user_data_base64
    tags                         = {
        "Name" = var.instance_name
    }
    vpc_security_group_ids       = [aws_security_group.terra_sg.id]

    
     dynamic "network_interface" {
    for_each = var.network_interface
    content {
      device_index          = network_interface.value.device_index
      network_interface_id  = lookup(network_interface.value, "network_interface_id", null)
      delete_on_termination = lookup(network_interface.value, "delete_on_termination", true)
    }
  }
    
    credit_specification {
        cpu_credits = "standard"
    }

    metadata_options {
        http_endpoint               = "enabled"
        http_put_response_hop_limit = 1
        http_tokens                 = "optional"
    }

    root_block_device {
        delete_on_termination = true
        encrypted             = false
        iops                  = 100
        volume_size           = 8
    }

    timeouts {}
}
######################
# VOLUME
######################      

  resource "aws_ebs_volume" "terra_vol" {
  count = var.ebs_volume_enabled == true ? 1 : 0
  availability_zone = data.aws_availability_zones.ad.names[0]
  size              = var.ebs_volume_size
  iops              = local.ebs_iops
  type              = var.ebs_volume_type
  #tags             = aws_instance.terra_inst.tags/"${var.vol_name}"
  tags              = {
    "Name" = format("%s_%s", lookup(aws_instance.terra_inst.tags,"Name"),var.vol_name) 
  }
}

resource "aws_volume_attachment" "terra_vol_attach" {
  count = var.ebs_volume_enabled == true ? 1 : 0
  device_name = var.ebs_device_name[count.index]
  volume_id   = aws_ebs_volume.terra_vol.*.id[count.index]
  instance_id = join("", aws_instance.terra_inst.*.id)
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

