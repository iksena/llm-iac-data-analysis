# ── variables.tf ────────────────────────────────────
# AliCloud account region and autehntication 
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
        us-east-1   = "us-east-1a"
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

# COMPUTE INSTANCE INFO
  variable hostname {
    default = "TerraHost"
}
  variable "instance_name" {
        default = "TerraCompute"
      }

 
  variable "instance_type" {
        default = "ecs.c5.large" # FREE TIERE for 3 months or ecs.t5-lc1m1.small for 1 year
        #shared ecs.n1.tiny ecs.xn4.small
        # 2C4G free tier 3 months > 2x ecs.c6.large . 100G .5/mbs (enteprise)
        # 1C1G free tier 1 YEAR >  1x ecs.t5-lc1m1.small 40g 1/mbs | burstable only available in APAC regions 
        # region supporting 1 year Free tier without ID: "cn-hongkong" i.e Zone:cn-hongkong-b
      }
  variable "img_id" {
        type = map

        default = {
        CENTOS8   = "centos_8_5_uefi_x64_20G_alibase_20220328.vhd"
        CENTOS7   = "centos_7_9_uefi_x64_20G_alibase_20230816.vhd" # Centos 7
        RHEL8     = "m-t4n1vfii5zftauvd5axj" #8.8
        UBUNTU    = "ubuntu_22_04_uefi_x64_20G_alibase_20230515.vhd"
        ROCKY9    = "rockylinux_9_2_x64_20G_alibase_20230613.vhd"  
        WINDOWS   = "win2022_21H2_x64_dtc_en-us_40G_alibase_20230915.vhd"
        SUSE      = "sles_12_sp4_x64_20G_alibase_20200319.vhd"
        Aliyun    = "aliyun_3_x64_20G_qboot_alibase_20230727.vhd"
       }
     }  

  variable "OS" {
  description = "the selected ami based OS"
  default       = "CENTOS7" 
}


# BOOT INFO   
 variable "preserve_boot_volume" {
    default = false
      }
 variable "boot_volume_size" {
      default = "20"
      }   
variable "data_diks_size" {
      default = "20"
      }
# user data
variable "user_data" {
        default = "./cloud-init/centos_userdata.txt" # "./cloud-init/vm.cloud-config"
      }     

variable "key_name" {
      default= "demo_ali_KeyPair"
      }


variable ssh_public_key {
  default = "~/.ssh/id_rsa_ali.pub"

}
# VNIC INFO
        variable "private_ip" {
        default = "192.168.10.51"
      }

 # EBS 
/*
variable "ebs_volume_size" {
       type        = number
       default     = 20 # up to 40GB fr free tier
       description = "Size of the ebs volume in gigabytes."
      }
      variable "ebs_device_name" {
      type        = list(string)
      default     = ["/dev/xvdb", "/dev/xvdc", "/dev/xvdd", "/dev/xvde", "/dev/xvdf", "/dev/xvdg", "/dev/xvdh", "/dev/xvdi", "/dev/xvdj", "/dev/xvdk", "/dev/xvdl", "/dev/xvdm", "/dev/xvdn", "/dev/xvdo", "/dev/xvdp", "/dev/xvdq", "/dev/xvdr", "/dev/xvds", "/dev/xvdt", "/dev/xvdu", "/dev/xvdv", "/dev/xvdw", "/dev/xvdx", "/dev/xvdy", "/dev/xvdz"]
      description = "Name of the EBS device to mount."
      }
*/ 

  


# ── outputs.tf ────────────────────────────────────
## VPC OUTPUT
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
##  INSTANCE OUTPUT
      output "instance_id" {
        description = " id of created instances. "
        value       = alicloud_instance.terra_inst.id
      }
      
      output "private_ip" {
        description = "Private IPs of created instances. "
        value       = alicloud_instance.terra_inst.primary_ip_address 
      }
      
      output "public_ip" {
        description = "Public IPs of created instances. "
        value       = alicloud_instance.terra_inst.public_ip
      }

 output "SSH_Connection" {
     value      = format("ssh connection to instance ${var.instance_name} ==> sudo ssh -i ~/.ssh/id_rsa_ali root@%s",alicloud_instance.terra_inst.public_ip)
}

  
  
    

# ── compute.tf ────────────────────────────────────
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
######################
# DATA SOURCE
######################

 /*
data "alicloud_vswitches" "terrasub" {
  name_regex   = "${alicloud_vswitch.vswitch.vswitch_name}"
  vpc_id       =
  vswitch_name =
  zone_id      =
}
*/
######################
# INSTANCE
######################

 data "alicloud_images" "centos7" {
 most_recent = true
 owners = "system"
 name_regex = "^centos_7"
}

resource "alicloud_key_pair" "key_pair" {
  key_pair_name     = var.key_name
  public_key        = file(var.ssh_public_key) # file(~/.ssh/id_rsa_ali.pub)
  resource_group_id = alicloud_resource_manager_resource_group.rg.id
}

resource "alicloud_instance" "terra_inst" {
  image_id              = var.img_id[var.OS]
  instance_type         = var.instance_type # "ecs.t5-lc1m1.small"  # Free Tier eligible
  host_name             = var.hostname
  availability_zone     = var.ali_zone[var.ali_region]
  resource_group_id     = alicloud_resource_manager_resource_group.rg.id
  security_groups       = [alicloud_security_group.terra_sg.id]
  internet_charge_type  = "PayByTraffic" # Set to PayByTraffic for Free Tier eligibility
  internet_max_bandwidth_out = 1   # Free Tier eligible / larger than 0 will allocate a public ip address
  instance_name         = "example-instance"
  instance_charge_type  = "PostPaid" # Set to Pay-As-You-Go for Free Tier eligibility
  stopped_mode          = "StopCharging"
  key_name              = var.key_name
  system_disk_name      = "root_disk"
  system_disk_category  = "cloud_efficiency"  # Use the free tier system disk
  system_disk_size      = var.boot_volume_size # Up to 40G for the free tier system disk size
  vswitch_id            = alicloud_vswitch.terra_sub.id  # Associate with a VSwitch
  private_ip            = var.private_ip  # Assign a private IP
  user_data             = filebase64(var.user_data) 
#  security_enhancement_strategy = "Active"

# allocate_public_ip   =  deprecated from version "1.7.0" see "internet_max_bandwidth_out"
# eip_options {  in case Elastic IP Address is needed 
#    bandwidth = 1
#    internet_charge_type = "PayByTraffic"
#    isp = "BGP"
#  }
## DATA DISKS
/*
  data_disks {
    name        = "disk1"
    size        = "20"
    category    = "cloud_efficiency"
    description = "disk1"
    delete_with_instance = true  # default
  }
  data_disks {
    name        = "disk2"
    size        = "20"
    category    = "cloud_ssd"
    description = "disk2"
    encrypted   = true
    kms_key_id  = alicloud_kms_key.key.id
    delete_with_instance = false
  }
  */
}

######################
# VOLUME
######################      
/*
resource "alicloud_ecs_disk" "disk" {
  zone_id           = var.ali_zone[var.ali_region] OR "instance_id = alicloud_instance.terra_inst.id"
  disk_name   = "terraform-example"
  description = "terraform-example"
  category          = var.disk_category
  size              = var.disk_size
  delete_with_instance = "true"
  count             = var.disk_number # 
}

resource "alicloud_ecs_disk_attachment" "instance-attachment" {
  count       = var.number
  disk_id     = alicloud_disk.disk.*.id[count.index]
  instance_id = alicloud_instance.terra_inst.id
}

*/

# ── vpc.tf ────────────────────────────────────
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