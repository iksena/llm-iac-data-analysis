# ── variables.tf ────────────────────────────────────
provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

############################
#  Hidden Variable Group   #
############################
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

variable "main_compartment_name" {
  default = "mycomp"
}
variable "main_compartment_desc" {
  default = "Enclosing compartment at root level"
}

variable "app_compartment_name" {
  default = "comp-app"
}
######################
# locals : compartment 
######################
# all cases in one map 
locals {
  compartments = {
    l1_subcomp = {
      comp-shared                = "for shared services like AD, Commvault,Monitoring"
      comp-network               = "for all FW, VCNs and LBRs"
      comp-security              = "for Security related resources like Vaults, keys"
      (var.app_compartment_name) = "Parent compartment for all application resources"
    },
    l2_subcomp = {
      "${var.app_compartment_name}-prod"  = " production VMs"
      "${var.app_compartment_name}-nprod" = "non-production VMs"
      "${var.app_compartment_name}-dr"    = "DR VMs"
      "${var.app_compartment_name}-db"    = "Database instances and resources"
    }
  }
}


############################
# Additional Configuration #
############################

# ── compartments.tf ────────────────────────────────────
# ---- Terraform Version
terraform {
  required_version = ">= 1.0.3" # ">= 0.12, < 0.13" this example is intended to run with Terraform v0.12
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "4.105.0"
    }
  }
}
#########################################################
# compartement and two sub-compartemnt using iam modules.
# Author Brokedba https://twitter.com/BrokeDba
#########################################################

#module "iam" {
#  source  = "oracle-terraform-modules/iam/oci"
#  version = "2.0.2"
#}


resource "oci_identity_compartment" "iam_compartment_main" {
  #Required
  compartment_id = var.tenancy_ocid
  description    = var.main_compartment_desc
  name           = var.main_compartment_name
  #Optional
  #    defined_tags = {"Operations.CostCenter"= "42"}
  #    freeform_tags = {"Department"= "Finance"}
}


module "level_1_sub_compartments" {
  source   = "./modules/iam-compartment"
  for_each = local.compartments.l1_subcomp
  #tenancy_ocid            = var.tenancy_ocid # optional
  compartment_id          = oci_identity_compartment.iam_compartment_main.id # define the parent compartment. Here we make reference to the previous module
  compartment_name        = each.key
  compartment_description = each.value
  compartment_create      = true # if false, a data source with a matching name is created instead
  enable_delete           = true # if false, on `terraform destroy`, compartment is deleted from the terraform state but not from oci 
}

data "oci_identity_compartments" "app_comp" {
  #Required
  compartment_id = oci_identity_compartment.iam_compartment_main.id
  #Optional
  #compartment_id_in_subtree = true
  name       = var.app_compartment_name
  depends_on = [module.level_1_sub_compartments, ]
}


module "level_2_sub_compartments" {
  source                  = "./modules/iam-compartment"
  for_each                = local.compartments.l2_subcomp
  compartment_id          = data.oci_identity_compartments.app_comp.compartments[0].id # define the parent compartment. Here we make reference to the previous module
  compartment_name        = each.key
  compartment_description = each.value
  compartment_create      = true # if false, a data source with a matching name is created instead
  enable_delete           = true # if false, on `terraform destroy`, compartment is deleted from the terraform state but not from oci 

  depends_on = [module.level_1_sub_compartments, ]
}


# ── output.tf ────────────────────────────────────
output "main_compartment" {
  value = {
    Comp_name = oci_identity_compartment.iam_compartment_main.name
    comp_desc = oci_identity_compartment.iam_compartment_main.description
    comp_ocid = oci_identity_compartment.iam_compartment_main.id
  }
}

output "l1_sub_compartment" {
  value = {
    comp_name = module.level_1_sub_compartments[var.app_compartment_name].compartment_name

  }
}
output "l1_sub_compartments" {
  description = "Shows all level one subcompartments details "
  #value       = {for k,v in aws_security_group_rule.terra_sg_rule : k => v.to_port}
  value = { for comp, p in module.level_1_sub_compartments : comp => format("%s => Desc: %s", p.compartment_id, p.compartment_description) }
}

output "l2_sub_compartments" {
  description = "Shows all level one subcompartments details "
  #value       = {for k,v in aws_security_group_rule.terra_sg_rule : k => v.to_port}
  value = { for comp, p in module.level_2_sub_compartments : comp => format("%s => Desc: %s", p.compartment_id, p.compartment_description) }
}

output "comp-network-ocid" {
  value = module.level_1_sub_compartments["comp-network"].compartment_id
}

output "comp-security-ocid" {
  value = module.level_1_sub_compartments["comp-security"].compartment_id
}

output "comp-shared-ocid" {
  value = module.level_1_sub_compartments["comp-shared"].compartment_id
}
output "comp-app-ocid" {
  value = module.level_1_sub_compartments[var.app_compartment_name].compartment_id
}
output "comp-app-db-ocid" {
  value = module.level_2_sub_compartments["${var.app_compartment_name}-db"].compartment_id
}

output "comp-app-prod-ocid" {
  value = module.level_2_sub_compartments["${var.app_compartment_name}-prod"].compartment_id
}

output "comp-app-nprod-ocid" {
  value = module.level_2_sub_compartments["${var.app_compartment_name}-nprod"].compartment_id
}

output "comp-app-dr-ocid" {
  value = module.level_2_sub_compartments["${var.app_compartment_name}-dr"].compartment_id
}

 