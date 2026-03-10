# ── variables.tf ────────────────────────────────────

variable "compartment_ocid" {}
variable "tenancy_ocid" {}
variable "region" {}
variable "fingerprint" {}
variable "user_ocid" {}
#variable "public_key_path" {}
variable "private_key_path" {}
variable "availability_domain" {
  default = "BahF:CA-TORONTO-1-AD-1"
    }    # CHANGE ME
variable "vcn_display_name" {
  default = "db-vcn"
}

variable "vcn_cidr" {
  default = "192.168.64.0/20"
}

variable "vcn_dns_label" {
  default = "terravcn"
}
# SUBNET INFO
variable "subnet_db_dns_label" {
  default = "dbsubnet"
}
variable "subnet_db_display_name" {
  default = "db-sub"
}
variable "subnet_app_dns_label" {
  default = "appsubnet"
}
variable "subnet_app_display_name" {
  default = "app-sub"
}

variable "subnet_cidr" {
  default = "192.168.78.0/24"
}
variable "subnet_cidr2" {
  default = "192.168.79.0/24"
}

provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  region       = var.region
}
#################
# DB System
#################

variable "db_system_shape" {
  default = "VM.Standard.E4.Flex"  #"VM.Standard2.4"
}

variable "db_edition" {
  default = "STANDARD_EDITION"
}

# VNIC INFO
variable "db_system_private_ip" {
  default = "192.168.78.10"
}
variable "db_admin_password" {
}

variable "db_name" {
  default = "MYCDB"
}

variable "db_version" {
  default = "21.0.0.0"
}

/* 
valid list : 
11.2.0.4 or 11.2.0.4.201020 or 11.2.0.4.210119 or 11.2.0.4.210420 or 12.1.0.2 or 12.1.0.2.210420 or 12.1.0.2.210720 or 
12.1.0.2.211019 or 12.2.0.1 or 12.2.0.1.210420 or 12.2.0.1.210720 or 12.2.0.1.211019 or 18.0.0.0 or 18.13.0.0 or 
18.14.0.0 or 18.16.0.0 or 19.0.0.0 or 19.11.0.0 or 19.12.0.0 or 19.13.0.0 or 21.0.0.0 or 21.3.0.0 or 21.4.0.0.
*/

variable "db_home_display_name" {
  default = "DBHome19"
}

variable "db_disk_redundancy" {
  default = "HIGH"
}

variable "db_system_display_name" {
  default = "DBCSDEMO"
}

variable "hostname" {
  default = "hopsdb-oci"
}

variable "host_user_name" {
  default = "opc"
}

variable "n_character_set" {
  default = "AL16UTF16"
}

variable "character_set" {
  default = "WE8ISO8859P15"
}

variable "db_workload" {
  default = "OLTP"
}

variable "pdb_name" {
  default = "PDB1"
}

variable "data_storage_size_in_gb" {
  default = "256"
}

variable "license_model" {
  default = "LICENSE_INCLUDED"
}

variable "node_count" {
  default = "1"
}

variable "db_system_cpu_core_count" {
default = "2"
}

variable "data_storage_percentage" {
  default = "40"
}


variable "db_auto_backup_enabled" {
  default = "true"
}

variable "db_auto_backup_window" {
  default = "SLOT_TWO"
}

variable "db_recovery_window_in_days" {
  default = "45"
}

variable "ssh_public_key" {
  # default = "~/id_rsa_oci.pub"
}


##############
# Object Storage
##############
variable "bucket_name" {
  default = "Mybucket"
}

# Dictionary Locals
locals {
}

##########################
#   BASTION SERVICE
##########################

variable "bastion_cidr_block_allow_list" {
    default= "0.0.0.0/0"
}

variable "bastion_name" {
    default = "BastionMyDB"
}

variable "session_session_ttl_in_seconds" {
    default = "10800"
  
}

variable "session_target_resource_details_session_type" {
 default = ""
 }

variable "bastion_session_type" {
default = "PORT_FORWARDING"

}
variable "bastion_session_name" {
    default = "Session-Mybastion"
  
}



# ── outputs.tf ────────────────────────────────────

output "vcn_id" {
  description = "OCID of created VCN. "
  value       = oci_core_virtual_network.vcnterra.id
}
output "vcn_name" {
  description = "The Name of the newly created vpc"
  value       = oci_core_virtual_network.vcnterra.display_name
}


output "Subnet_Name_DB" {
  description = "Name of created vcn's Subnet. "
  value       = oci_core_subnet.terraDB.display_name
}
output "Subnet_CIDR_DB" {
  description = "cidr block of vcn's Subnet. "
  value       = oci_core_subnet.terraDB.cidr_block
}


##  INSTANCE OUTPUT

output "hostname" {
  description = " id of created instances. "
  value       = oci_database_db_system.MYDBSYS.hostname
}

output "private_ip" {
  description = "Private IPs of created instances. "
  value       = oci_database_db_system.MYDBSYS.private_ip
}


output "DB_STATE" {
  value = oci_database_db_system.MYDBSYS.state
}

output "DB_Version" {
  value = oci_database_db_system.MYDBSYS.version

}
output "db_system_options" {
  value = oci_database_db_system.MYDBSYS.db_system_options

}

######### 
# BASTION
#########

output "bastion_name" {
  value = oci_bastion_session.mybastion_session.bastion_name 

}

output "bastion_session_name" {
  value = oci_bastion_session.mybastion_session.display_name

}

/*output "Bastion_session_key_details" {
  value = oci_bastion_session.mybastion_session.key_details
}
*/
output "bastion_session_state" {
  value = oci_bastion_session.mybastion_session.state

}

output "bastion_session_target_resource_details" {
  value = oci_bastion_session.mybastion_session.target_resource_details

}

output "bastion_session_ssh_connection" {
  value = oci_bastion_session.mybastion_session.ssh_metadata.command

} 

 
/*
output "bastion_session_target_IP" {
  value = oci_bastion_session.mybastion_session.target_resource_private_ip_address

}

output "bastion_session_target_port" {
  value = oci_bastion_session.mybastion_session.target_resource_port 

}
 
*/


# ── bastion.tf ────────────────────────────────────


resource "oci_bastion_bastion" "mybastion" {
    #Required
    bastion_type = "standard"
    compartment_id = var.compartment_ocid
    target_subnet_id = oci_core_subnet.terraDB.id
     #oci_core_subnet.db_subnet.id
    name = var.bastion_name
    client_cidr_block_allow_list = [var.bastion_cidr_block_allow_list]
/*
    #Optional
    client_cidr_block_allow_list = var.bastion_cidr_block_allow_list
    #defined_tags = {"foo-namespace.bar-key"= "value"}
    freeform_tags = {"bar-key"= "value"}
    max_session_ttl_in_seconds = "10800"
    phone_book_entry = var.bastion_phone_book_entry
   # static_jump_host_ip_addresses = var.bastion_static_jump_host_ip_addresses
*/
}


##################################
#    Bastion Session
##################################
resource "oci_bastion_session" "mybastion_session" {
    #Required
    bastion_id = oci_bastion_bastion.mybastion.id
    key_details {
        #Required
        public_key_content = file(var.ssh_public_key)
    }
    target_resource_details {
        #Required
        session_type = var.bastion_session_type

        #Optional
        target_resource_port = "22" #var.bastion_session_port
        target_resource_private_ip_address = "192.168.78.10"  # oci_database_db_system.MYDBSYS.private_ip
        # target_resource_id = oci_bastion_target_resource.test_target_resource.id      -->MANAGED_SSH
        # target_resource_operating_system_user_name = oci_identity_user.test_user.name -->MANAGED_SSH
    }

    #Optional
    display_name = var.bastion_session_name  #Session-Mybastion
    key_type = "PUB"
    session_ttl_in_seconds = var.session_session_ttl_in_seconds #"10800"
     
}


# ── database.tf ────────────────────────────────────

resource "oci_database_db_system" "MYDBSYS" {
  availability_domain = data.oci_identity_availability_domains.ad1.availability_domains[0].name
  compartment_id      = var.compartment_ocid
  #cpu_core_count      = data.oci_database_db_system_shapes.db_system_shapes.db_system_shapes[0]["minimum_core_count"]
  database_edition = var.db_edition

  db_home {
    database {
      admin_password = var.db_admin_password
      db_name        = var.db_name
      pdb_name       = var.pdb_name
      character_set  = var.character_set
      ncharacter_set = var.n_character_set
      db_workload    = var.db_workload
      db_backup_config {
        auto_backup_enabled     = var.db_auto_backup_enabled
        auto_backup_window      = var.db_auto_backup_window
        recovery_window_in_days = var.db_recovery_window_in_days
      }
    }
    db_version = var.db_version
  }

  shape                   = var.db_system_shape
  license_model           = var.license_model
  subnet_id               = oci_core_subnet.terraDB.id
  private_ip              = var.db_system_private_ip
  ssh_public_keys         = [file(var.ssh_public_key),] 
  hostname                = var.hostname
  data_storage_size_in_gb = var.data_storage_size_in_gb
  node_count              = data.oci_database_db_system_shapes.db_system_shapes.db_system_shapes[0]["minimum_node_count"]
  display_name = var.db_system_display_name
  cpu_core_count = var.db_system_cpu_core_count
  # defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}


/* Other optional arguments
- source - (Optional) The source of the database: Use NONE for creating a new database. 
  Use DB_BACKUP for creating a new database by restoring from a backup. 
  Use DATABASE for creating a new database from an existing database, including archive redo log data. The default is NONE.
- source_db_system_id - (Required when source=DB_SYSTEM) The OCID of the DB system.
*/


# ── datasources.tf ────────────────────────────────────
## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Get the latest Oracle Linux image


# Get DB node list
data "oci_database_db_nodes" "db_nodes1" {
  compartment_id = var.compartment_ocid
  db_system_id   = oci_database_db_system.MYDBSYS.id
}

## Get DB node details
data "oci_database_db_node" "db_node_details1" {
  db_node_id = data.oci_database_db_nodes.db_nodes1.db_nodes[0]["id"]
}


# Gets the OCID of the first (default) vNIC
data "oci_core_vnic" "db_node_vnic1" {
  vnic_id = data.oci_database_db_node.db_node_details1.vnic_id
}


data "oci_database_db_homes" "db_homes1" {
  compartment_id = var.compartment_ocid
  db_system_id   = oci_database_db_system.MYDBSYS.id
}


data "oci_database_databases" "databases1" {
  compartment_id = var.compartment_ocid
  db_home_id     = data.oci_database_db_homes.db_homes1.db_homes[0].db_home_id
}


data "oci_database_db_system_patches" "patches1" {
  db_system_id = oci_database_db_system.MYDBSYS.id
}

data "oci_database_db_system_patch_history_entries" "patches_history1" {
  db_system_id = oci_database_db_system.MYDBSYS.id
}


data "oci_database_db_home_patches" "patches1" {
  db_home_id = data.oci_database_db_homes.db_homes1.db_homes[0].db_home_id
}


data "oci_database_db_home_patch_history_entries" "patches_history1" {
  db_home_id = data.oci_database_db_homes.db_homes1.db_homes[0].db_home_id
}


data "oci_database_db_versions" "test_db_versions_by_db_system_id1" {
  compartment_id = var.compartment_ocid
  db_system_id   = oci_database_db_system.MYDBSYS.id
}


data "oci_database_db_system_shapes" "db_system_shapes" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid

  filter {
    name   = "shape"
    values = [var.db_system_shape]
  }
}

 


# ── vcn.tf ────────────────────────────────────

terraform {
  required_version = ">= 0.12.0"
}
#################
# VCN
#################

resource "oci_core_virtual_network" "vcnterra" {
  dns_label      = var.vcn_dns_label
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_ocid
  display_name   = var.vcn_display_name
}

#################
# Storage Services
#################
data "oci_core_services" "oci_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}
data "oci_core_services" "object_storage_svcs" {
  filter {
    name   = "name"
    values = [".*Object.*Storage"]
    regex  = true
  }
}

######################
# Internet Gateway
######################    
resource "oci_core_internet_gateway" "igtw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcnterra.id
  display_name   = "terra-igw"
  enabled        = "true"
}
#####################
# NAT Gateway
#####################

resource "oci_core_nat_gateway" "natgw" {
  compartment_id = var.compartment_ocid
  display_name   = "${lower(var.vcn_display_name)}-natgw"
  vcn_id         = oci_core_virtual_network.vcnterra.id
  # defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}
########################
# Object Service gateway
########################
resource "oci_core_service_gateway" "obj-svcgw" {
  compartment_id = oci_core_virtual_network.vcnterra.compartment_id

  services {
    service_id = data.oci_core_services.object_storage_svcs.services[0]["id"]
  }

  vcn_id       = oci_core_virtual_network.vcnterra.id
  display_name = "${lower(var.vcn_display_name)}-obj-storage-svcgw"
}

/*  Service gateway if DBCS needed more than object storage access
resource "oci_core_service_gateway" "sg" {
  compartment_id = var.compartment_ocid
  services {
    service_id = data.oci_core_services.oci_services.services.0.id
  }
  display_name = "service-gateway"
  vcn_id       = oci_core_virtual_network.vcnterra.id
}
*/
#####################
# Dynamic Routing GW
#####################
resource "oci_core_drg" "drgw" {
  compartment_id = oci_core_virtual_network.vcnterra.compartment_id
  display_name   = "${lower(var.vcn_display_name)}-drgw"
}

resource "oci_core_drg_attachment" "drgw_attachment" {
  drg_id = oci_core_drg.drgw.id
  vcn_id = oci_core_virtual_network.vcnterra.id
}
######################
# Route Tables
######################       
#default
resource "oci_core_default_route_table" "rt" {
  manage_default_resource_id = oci_core_virtual_network.vcnterra.default_route_table_id
  /*   route_rules {
        destination       = Onprem_servers
        destination_type  = "CIDR_BLOCK"
        network_entity_id = oci_core_drg.drgw.id
    }
    */
  route_rules {
    destination       = data.oci_core_services.object_storage_svcs.services[0]["cidr_block"]
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.obj-svcgw.id
  }

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.natgw.id
  }
}

resource "oci_core_route_table" "apprt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcnterra.id
  display_name   = "App-rt-table"
/* No need for a service gateway route for public subnets  
 # route_rules {
 #   destination       = lookup(data.oci_core_services.oci_services.services[0], "cidr_block")
 #   destination_type  = "SERVICE_CIDR_BLOCK"
 #   network_entity_id = oci_core_service_gateway.sg.id
 # }
 */
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.igtw.id
  }

#     route_rules {
#    destination       = "0.0.0.0/0"
#    destination_type  = "CIDR_BLOCK"
#    network_entity_id = oci_core_nat_gateway.natgw.id
#  }
}

######################
# Security Lists
######################

resource "oci_core_security_list" "terra_sl" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcnterra.id
  display_name   = "terra-sl"
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
  # ingress_security_rules {
  #   protocol = "6"
  #   source   = "0.0.0.0/0"

  #    tcp_options {
  #      min = 80
  #      max = 80
  #    }
  #  }

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
    source   = var.subnet_cidr2

    tcp_options {
      max = 1521
      min = 1521
    }
  }
}

resource "oci_core_security_list" "terraApp_sl" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcnterra.id
  display_name   = "terra-sl"
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
  ingress_security_rules {
    protocol = "1"
    source   = "0.0.0.0/0"
  }

  ingress_security_rules {
        // Unrestricted access within local APP subnet
        protocol = "all"
        source   = var.subnet_cidr2
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
      min = 443
      max = 443
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

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"

    tcp_options {
      max = 1521
      min = 1521
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

resource "oci_core_subnet" "terraDB" {
  availability_domain        = data.oci_identity_availability_domains.ad1.availability_domains[0].name
  cidr_block                 = var.subnet_cidr
  display_name               = var.subnet_db_display_name
  prohibit_public_ip_on_vnic = false
  dns_label                  = var.subnet_db_dns_label #"${var.subnet_dns_label}${count.index + 1}"
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_virtual_network.vcnterra.id
  route_table_id             = oci_core_default_route_table.rt.id
  security_list_ids          = ["${oci_core_security_list.terra_sl.id}"]
  dhcp_options_id            = oci_core_virtual_network.vcnterra.default_dhcp_options_id
  #security_list_ids   = ["${oci_core_virtual_network.vcnterra.default_security_list_id}"]
}

resource "oci_core_subnet" "terraApp" {
  availability_domain        = data.oci_identity_availability_domains.ad1.availability_domains[0].name
  cidr_block                 = var.subnet_cidr2
  display_name               = var.subnet_app_display_name
  prohibit_public_ip_on_vnic = false
  dns_label                  = var.subnet_app_dns_label #"(${var.subnet_dns_label})-2"
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_virtual_network.vcnterra.id
  route_table_id             = oci_core_route_table.apprt.id
  security_list_ids          = ["${oci_core_security_list.terraApp_sl.id}"]
  dhcp_options_id            = oci_core_virtual_network.vcnterra.default_dhcp_options_id
  #security_list_ids   = ["${oci_core_virtual_network.vcnterra.default_security_list_id}"]
}


