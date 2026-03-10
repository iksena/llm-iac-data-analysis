# ── variables.tf ────────────────────────────────────
#########################################################
# Public IPs.
# Author Brokedba https://twitter.com/BrokeDba
#########################################################
provider "oci" {
  alias            = "primary"
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

provider "oci" {
  alias            = "dr"
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.dr_region
}
############################
#  Hidden Variable Group   #
############################
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "dr_region" {}

######################
# locals : 
######################
# all cases in one map 
locals {
  ips = {
    primary_site = {  # key (display_name) => value (description)
      mgmt-public_ip-vm-a = "Public IP for Firewall Primary VM management Interface" 
      mgmt-public_ip-vm-b = "Public IP for Firewall Secondary VM management Interface" 
      untrust-floating-public_ip = "Floating Public IP for Firewall Untrust Interface" 
      untrust-floating-public_ip_frontend_1 = "Floating Public IP for Firewall Untrust Interface inbound (frontend cluster ip)"
    },
    dr_site = {
      dr-mgmt-public_ip-vm-c = "DR Public IP for Firewall Primary VM management Interface" 
      dr-mgmt-public_ip-vm-d = "DR Public IP for Firewall Secondary VM management Interface"
      dr-untrust-floating-public_ip = "DR Floating Public IP for Firewall Untrust Interface"
      dr-untrust-floating-public_ip_frontend_1 = "DR Floating Public IP for Firewall Untrust Interface inbound (frontend cluster ip)"
      }
}
}

# ── output.tf ────────────────────────────────────
# display the Public Ips
output "Toronto_public_ips" {
      description = "Shows all public IPs and their OCIDs in Primary site [Toronto]"
      value        = { for ip,p in  oci_core_public_ip.primary_firewall_public_ip : ip => format("name: %s IP:%s OCID:%s",p.display_name,p.ip_address, p.id) }
}

output "Montreal_public_ips" {
      description = "Shows all public IPs and their OCIDs in DR site [Montreal]"
      value        = { for ip,p in  oci_core_public_ip.dr_firewall_public_ip : ip => format("name: %s IP:%s OCID:%s",p.display_name,p.ip_address, p.id) }
}

# ── publicip.tf ────────────────────────────────────
# ---- Terraform Version and configuration_aliases [primary Toronto, DR Montreal]
terraform {
required_version = ">= 1.0.3"     
required_providers {
 oci = {
      source  = "oracle/oci"
      version = "4.105.0"
      configuration_aliases =  [ oci.primary, oci.dr ]
   }
  }
}
 
 resource "oci_core_public_ip" "primary_firewall_public_ip" {
    provider = oci.primary
    #Required
    for_each = local.ips.primary_site
    compartment_id = var.tenancy_ocid
    lifetime = "RESERVED"
    #Optional
    display_name = each.key
    # ---- Vnics aren't available yet, No assignment needed
    #assignedEntityId = oci_core_private_ip.test_private_ip.id
    #public_ip_pool_id = oci_core_public_ip_pool.test_public_ip_pool.id
}

 resource "oci_core_public_ip" "dr_firewall_public_ip" {
    provider = oci.dr
    #Required
    for_each = local.ips.dr_site
    compartment_id = var.tenancy_ocid
    lifetime = "RESERVED"
    #Optional
    display_name = each.key

}