# ── variables.tf ────────────────────────────────────
#########################################################
# Author Brokedba https://twitter.com/BrokeDba
#########################################################
#Variables declared in this file must be declared in the marketplace.yaml
terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "4.105.0"
    }
  }
}

provider "oci" {
 tenancy_ocid = var.tenancy_ocid
 region       = var.region
 fingerprint    = var.fingerprint
 user_ocid      = var.user_ocid
 private_key_path = var.private_key_path
}
 
############################
#  Hidden Variable Group   #
############################
variable "tenancy_ocid" {}
variable "region" {}
variable "private_key_path" {}
variable "fingerprint" {}
variable "user_ocid" {}
variable "compartment_ocid" {}
##############################
#         VCN INFO           #  
##############################
    variable "vcn_display_name" {
      default = "Terravcn"
    }
    
    variable "vcn_cidr" {
      default = "192.168.64.0/20"
    }

    variable "vcn_dns_label" {
      default     = "Terra"
    }
# SUBNET INFO
    variable "subnet_dns_label" {
      default = "terra"
    }
    variable "subnet_display_name"{
      default = "terrasub" 
      }

    variable "subnet_cidr"{
      default = "192.168.78.0/24"
      }  
# COMPUTE INSTANCE INFO

      variable "instance_display_name" {
        default = "TerraCompute"
      }
      variable "extended_metadata" {
        default     = {}
      }
     # variable "ipxe_script" {}
      variable "preserve_boot_volume" {
        default = false
      }
      variable "boot_volume_size_in_gbs" {
        default = "50"
      }
      variable "shape" {
        default = "VM.Standard2.1" #"VM.Standard.E2.1.Micro"
      }
      variable "instance_image_ocid" {
        type = map

        default = {
        # See https://docs.us-phoenix-1.oraclecloud.com/images/
        # Oracle-provided image "Oracle-Linux-7.8-2020.04.17-0"
        us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaav3isrmykdh6r3dwicrdgpmfdv3fb3jydgh4zqpgm6yr5x3somuza"
        us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaahjkmmew2pjrcpylaf6zdddtom6xjnazwptervti35keqd4fdylca"
       ca-montreal-1  = "ocid1.image.oc1.ca-montreal-1.aaaaaaaamcmyjjewzrw7qz66lnsl4hf7mkaznw6iyrrdwc22z56vltj36mka"
       ca-toronto-1   = "ocid1.image.oc1.ca-toronto-1.aaaaaaaaw6w5y4vbjdg6gqptyagaq2o7kdj6mupblphd73qvfszufbvv2rfa"  # Centos 7
       }
     }     
# VNIC INFO
      variable "hostname_label" {
        default = "terrahost" 
      }
       variable "assign_public_ip" {
        default = true
      }
      variable "vnic_name" {
        default = "eth01"
      }
      variable "private_ip" {
        default = "192.168.78.51"
      }
      variable "skip_source_dest_check" {
        default = false
      }
     # variable "subnet_ocid" {}
# BOOT INFO      
      variable "ssh_public_key" {}
   #   variable "user_data" {}
      variable "instance_timeout" {
        default = "25m"
      }
      variable "block_storage_size_in_gbs" {
        default = "50"
      }
      variable "attachment_type" {
        default = "iscsi"
      }
      variable "use_chap" {
        description = "Whether to use CHAP authentication for the volume attachment. "
        default     = true
      }
      variable "resource_platform" { 
        description = "Platform to create resources in. "
        default     = "linux"
      }
      variable "instance_ocpus" {
      default = 1
      }        


# ── outputs.tf ────────────────────────────────────

    output "vcn_id" {
      description = "OCID of created VCN. "
      value       = oci_core_vcn.vcnterra.id
    }
    
    output "default_security_list_id" {
      description = "OCID of default security list. "
      value       = oci_core_vcn.vcnterra.default_security_list_id
    }
    
    output "default_dhcp_options_id" {
      description = "OCID of default DHCP options. "
      value       = oci_core_vcn.vcnterra.default_dhcp_options_id
    }
    
    output "default_route_table_id" {
      description = "OCID of default route table. "
      value       = oci_core_vcn.vcnterra.default_route_table_id
    }
    
    output "internet_gateway_id" {
      description = "OCID of internet gateway. "
      value       = oci_core_internet_gateway.gtw.id
    }
    
    output "subnet_ids" {
      description = "ocid of subnet ids. "
      value       = oci_core_subnet.terrasub.*.id
    }
##  INSTANCE OUTPUT

      output "instance_id" {
        description = "ocid of created instances. "
        value       = [oci_core_instance.terra_inst.id]
      }
      
      output "private_ip" {
        description = "Private IPs of created instances. "
        value       = [oci_core_instance.terra_inst.private_ip]
      }
      
      output "public_ip" {
        description = "Public IPs of created instances. "
        value       = [oci_core_instance.terra_inst.public_ip]
      }
  
  
    

# ── compute.tf ────────────────────────────────────

      terraform {
        required_version = ">= 0.12.0"
      }
######################
# DATA SOURCE
######################
      data "oci_core_images" "terra_img" {
        #Required
        compartment_id = var.compartment_ocid
        #Optional
        operating_system = "CentOS"
        operating_system_version = 7
        shape = var.shape         # "VM.Standard2.1" or  "VM.Standard.E2.1.Micro" 
        state = "AVAILABLE"
      }

      data "oci_core_subnet" "terrasub" {
    #Required
    #count     = length(data.oci_core_subnet.terrasub.id)
    #subnet_id =lookup(oci_core_subnet.terrasub[count.index],id)
    subnet_id = oci_core_subnet.terrasub[0].id
}
######################
# INSTANCE
######################

      resource "oci_core_instance" "terra_inst" {
        availability_domain  = data.oci_core_subnet.terrasub.availability_domain
        compartment_id       = var.compartment_ocid
        display_name         = var.instance_display_name  # "TerraCompute"
        preserve_boot_volume = var.preserve_boot_volume   # false
        shape                = var.shape                  # "VM.Standard2.1"

        create_vnic_details {
          assign_public_ip       = var.assign_public_ip       # true
          display_name           = var.vnic_name              # eth01
          hostname_label         = var.hostname_label         # terrahost
          private_ip             = var.private_ip             # true
          skip_source_dest_check = var.skip_source_dest_check # false
          subnet_id              = data.oci_core_subnet.terrasub.id
        }

        metadata = {
          ssh_authorized_keys = file(var.ssh_public_key)   #file("../../.ssh/id_rsa.pub")
          user_data = base64encode(file("./cloud-init/vm.cloud-config"))
        }

        source_details {
          boot_volume_size_in_gbs = var.boot_volume_size_in_gbs # 20G
          source_type = "image"
          source_id   = data.oci_core_images.terra_img.images[0].id
        }

        timeouts {
          create = var.instance_timeout # 25m
        }
      }
######################
# VOLUME
######################      

      resource "oci_core_volume" "terra_vol" {
        availability_domain = oci_core_instance.terra_inst.availability_domain
        compartment_id      = var.compartment_ocid
        display_name        = "${oci_core_instance.terra_inst.display_name}_volume_0"
        size_in_gbs         = var.block_storage_size_in_gbs # 20G
      }

      resource "oci_core_volume_attachment" "terra_attach" {
        attachment_type = var.attachment_type
       # compartment_id  = var.compartment_ocid  deprecated attribute
        instance_id     = oci_core_instance.terra_inst.id
        volume_id       = oci_core_volume.terra_vol.id
        use_chap        = var.use_chap  # true
      }
    


# ── vcn.tf ────────────────────────────────────

    terraform {
      required_version = ">= 0.12.0"
    }
#################
# VCN
#################
    
    resource oci_core_vcn "vcnterra" {
      dns_label      = var.vcn_dns_label
      cidr_block     = var.vcn_cidr
      compartment_id = var.compartment_ocid
      display_name   = var.vcn_display_name
    }
######################
# Internet Gateway
######################    
    resource oci_core_internet_gateway "gtw" {
      compartment_id = var.compartment_ocid
      vcn_id         = oci_core_vcn.vcnterra.id 
      display_name = "terra-igw"
      enabled = "true"
    }
######################
# Default Route Table
######################       

    resource "oci_core_default_route_table" "rt" {
      manage_default_resource_id = oci_core_vcn.vcnterra.default_route_table_id
    
      route_rules {
        destination       = "0.0.0.0/0"
        network_entity_id = oci_core_internet_gateway.gtw.id
      }
    }

resource "oci_core_security_list" "terra_sl" {
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_vcn.vcnterra.id
  display_name = "terra-sl"
  egress_security_rules {
     protocol    = "all"
    destination = "0.0.0.0/0"
  }
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 80
      max = 80
    }
  }

ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 22
      max = 22
    }
  }
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 443
      max = 443
    }
  }
}

######################
# Availability Domains
######################
    data "oci_identity_availability_domains" "ad1" {
      compartment_id = var.compartment_ocid
    }  
######################
# Subnet
######################

    resource "oci_core_subnet" "terrasub" {
      count               = length(data.oci_identity_availability_domains.ad1.availability_domains)
      availability_domain = lookup(data.oci_identity_availability_domains.ad1.availability_domains[count.index], "name")
     # cidr_block          = cidrsubnet(var.vcn_cidr, ceil(log(len527gth(data.oci_identity_availability_domains.ad1.availability_domains) * 2, 2)), count.index)
    #      display_name        = "Default Subnet ${lookup(data.oci_identity_availability_domains.ad1.availability_domains[count.index], "name")}"
      cidr_block     = var.subnet_cidr 
      display_name   = var.subnet_display_name
      prohibit_public_ip_on_vnic  = false
      dns_label                   = "${var.subnet_dns_label}${count.index + 1}"
      compartment_id              = var.compartment_ocid
      vcn_id                      = oci_core_vcn.vcnterra.id
      route_table_id              = oci_core_default_route_table.rt.id
      security_list_ids           = ["${oci_core_security_list.terra_sl.id}"]
      dhcp_options_id             = oci_core_vcn.vcnterra.default_dhcp_options_id
      #security_list_ids   = ["${oci_core_vcn.vcnterra.default_security_list_id}"]
    }
 
    