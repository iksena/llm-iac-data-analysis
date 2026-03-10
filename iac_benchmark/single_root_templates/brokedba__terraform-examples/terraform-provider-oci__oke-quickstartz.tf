# ── main.tf ────────────────────────────────────
# Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

# File Version: 0.8.0

################################################################################
#
#       *** Note: Normally, you should not need to edit this file. ***
#
################################################################################

################################################################################
# Module: OCI Vault (KMS) - Key Management Service to use with OKE
################################################################################
module "vault" {
  source = "./modules/oci-vault-kms"

  providers = {
    oci             = oci
    oci.home_region = oci.home_region
  }

  # Oracle Cloud Infrastructure Tenancy and Compartment OCID
  tenancy_ocid = var.tenancy_ocid

  # Deployment Tags + Freeform Tags + Defined Tags
  oci_tag_values = local.oci_tag_values

  # Encryption (OCI Vault/Key Management/KMS)
  use_encryption_from_oci_vault = var.use_encryption_from_oci_vault
  create_new_encryption_key     = var.create_new_encryption_key
  existent_encryption_key_id    = var.existent_encryption_key_id

  # OKE Cluster Details
  oke_cluster_compartment_ocid = local.oke_compartment_ocid

  ## Create Dynamic group and Policies for OCI Vault (Key Management/KMS)
  create_dynamic_group_for_nodes_in_compartment = var.create_dynamic_group_for_nodes_in_compartment
  create_compartment_policies                   = var.create_compartment_policies
  create_vault_policies_for_group               = var.create_vault_policies_for_group
}

################################################################################
# Module: Oracle Container Engine for Kubernetes (OKE) Cluster
################################################################################
module "oke" {
  source = "./modules/oke"

  # providers = {
  #   oci             = oci
  #   oci.home_region = oci.home_region
  # }

  # Oracle Cloud Infrastructure Tenancy and Compartment OCID
  tenancy_ocid     = var.tenancy_ocid
  compartment_ocid = local.oke_compartment_ocid
  region           = var.region
  cluster_type = var.cluster_type
  # Deployment Tags + Freeform Tags + Defined Tags
  cluster_tags        = local.oci_tag_values
  load_balancers_tags = local.oci_tag_values
  block_volumes_tags  = local.oci_tag_values

  # OKE Cluster
  ## create_new_oke_cluster
  create_new_oke_cluster  = var.create_new_oke_cluster
  existent_oke_cluster_id = var.existent_oke_cluster_id
  oke_cluster_oidc_discovery   = var.oke_cluster_oidc_discovery

  ## Network Details
  vcn_id                 = module.vcn.vcn_id
  network_cidrs          = local.network_cidrs
  k8s_endpoint_subnet_id = local.create_subnets ? module.subnets["oke_k8s_endpoint_subnet"].subnet_id : var.existent_oke_k8s_endpoint_subnet_ocid
  lb_subnet_id           = local.create_subnets ? module.subnets["oke_lb_subnet"].subnet_id : var.existent_oke_load_balancer_subnet_ocid
  cni_type               = local.cni_type
  ### Cluster Workers visibility
  cluster_workers_visibility = var.cluster_workers_visibility
  ### Cluster API Endpoint visibility
  cluster_endpoint_visibility = var.cluster_endpoint_visibility

  ## Control Plane Kubernetes Version
  k8s_version = var.k8s_version

  ## Create Dynamic group and Policies for Autoscaler and OCI Metrics and Logging
  # create_dynamic_group_for_nodes_in_compartment = var.create_dynamic_group_for_nodes_in_compartment
  # create_compartment_policies                   = var.create_compartment_policies

  ## Encryption (OCI Vault/Key Management/KMS)
  oci_vault_key_id_oke_secrets      = module.vault.oci_vault_key_id
  oci_vault_key_id_oke_image_policy = module.vault.oci_vault_key_id
}

################################################################################
# Module: OKE Node Pool
################################################################################
module "oke_node_pools" {
  for_each = { for map in local.node_pools : map.node_pool_name => map }
  source   = "./modules/oke-node-pool"

  # Deployment Tags + Freeform Tags
  node_pools_tags   = local.oci_tag_values
  worker_nodes_tags = local.oci_tag_values

  # Oracle Cloud Infrastructure Tenancy and Compartment OCID
  tenancy_ocid = var.tenancy_ocid

  # OKE Cluster Details
  oke_cluster_ocid             = module.oke.oke_cluster_ocid
  oke_cluster_compartment_ocid = local.oke_compartment_ocid
  create_new_node_pool         = var.create_new_oke_cluster

  # OKE Worker Nodes (Compute)
  node_pool_name                            = try(each.value.node_pool_name, "no_pool_name")
  node_pool_min_nodes                       = try(each.value.node_pool_min_nodes, 1)
  node_pool_max_nodes                       = try(each.value.node_pool_max_nodes, 3)
  node_k8s_version                          = try(each.value.node_k8s_version, var.k8s_version)
  node_pool_shape                           = each.value.node_pool_shape
  node_pool_shape_specific_ad               = try(each.value.node_pool_shape_specific_ad, 0)
  node_pool_node_shape_config_ocpus         = try(each.value.node_pool_node_shape_config_ocpus, 4)
  node_pool_boot_volume_size_in_gbs         = try(each.value.node_pool_boot_volume_size_in_gbs, 80)
  node_pool_node_shape_config_memory_in_gbs = try(each.value.node_pool_node_shape_config_memory_in_gbs, 48)
  existent_oke_nodepool_id_for_autoscaler   = try(each.value.existent_oke_nodepool_id_for_autoscaler, null)
  node_pool_autoscaler_enabled              = try(each.value.node_pool_autoscaler_enabled, true)
  node_pool_oke_init_params                 = try(each.value.node_pool_oke_init_params, "")
  node_pool_cloud_init_parts                = try(each.value.node_pool_cloud_init_parts, [])
  public_ssh_key                            = try(local.workers_public_ssh_key, "")
  image_operating_system                    = try(each.value.image_operating_system, "Oracle Linux")
  image_operating_system_version            = try(each.value.image_operating_system_version, "8")
  extra_initial_node_labels                 = try(each.value.extra_initial_node_labels, {})
  cni_type                                  = try(each.value.cni_type, "FLANNEL_OVERLAY")

  # OKE Network Details
  # nodes_subnet_id                       = local.create_subnets ? module.subnets["oke_nodes_subnet"].subnet_id : var.existent_oke_nodes_subnet_ocid
  nodes_subnet_id = (local.create_subnets ? (anytrue([(each.value.node_pool_alternative_subnet == ""), (each.value.node_pool_alternative_subnet == null)])
    ? module.subnets["oke_nodes_subnet"].subnet_id : module.subnets[each.value.node_pool_alternative_subnet].subnet_id)
  : var.existent_oke_nodes_subnet_ocid)
  vcn_native_pod_networking_subnet_ocid = each.value.cni_type == "OCI_VCN_IP_NATIVE" ? (local.create_subnets ? module.subnets["oke_pods_network_subnet"].subnet_id : var.existent_oke_vcn_native_pod_networking_subnet_ocid) : null

  # Encryption (OCI Vault/Key Management/KMS)
  oci_vault_key_id_oke_node_boot_volume = module.vault.oci_vault_key_id
}
locals {
  node_pool_1 = [
    {
      node_pool_name                            = var.node_pool_name_1 != "" ? var.node_pool_name_1 : "pool1" # Must be unique
      node_pool_min_nodes                       = var.node_pool_initial_num_worker_nodes_1
      node_pool_max_nodes                       = var.node_pool_max_num_worker_nodes_1
      node_pool_autoscaler_enabled              = var.node_pool_autoscaler_enabled_1
      node_k8s_version                          = var.k8s_version # TODO: Allow to set different version for each node pool
      node_pool_shape                           = var.node_pool_instance_shape_1.instanceShape
      node_pool_shape_specific_ad               = var.node_pool_shape_specific_ad_1
      node_pool_node_shape_config_ocpus         = var.node_pool_instance_shape_1.ocpus
      node_pool_node_shape_config_memory_in_gbs = var.node_pool_instance_shape_1.memory
      node_pool_boot_volume_size_in_gbs         = var.node_pool_boot_volume_size_in_gbs_1
      existent_oke_nodepool_id_for_autoscaler   = var.existent_oke_nodepool_id_for_autoscaler_1
      node_pool_oke_init_params                 = var.node_pool_oke_init_params_1
      node_pool_cloud_init_parts                = var.node_pool_cloud_init_parts_1
      node_pool_alternative_subnet              = null
      image_operating_system                    = var.image_operating_system_1
      image_operating_system_version            = var.image_operating_system_version_1
      extra_initial_node_labels                 = var.extra_initial_node_labels_1
      cni_type                                  = local.cni_type
    },
  ]
}
# Generate ssh keys to access Worker Nodes, if generate_public_ssh_key=true, applies to the pool
resource "tls_private_key" "oke_worker_node_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
locals {
  workers_public_ssh_key = var.generate_public_ssh_key ? tls_private_key.oke_worker_node_ssh_key.public_key_openssh : var.public_ssh_key
}

################################################################################
# Module: OKE Cluster Autoscaler
################################################################################
module "oke_cluster_autoscaler" {
  source = "./modules/oke-cluster-autoscaler"

  # Oracle Cloud Infrastructure Tenancy and Compartment OCID
  region = var.region

  ## Enable Cluster Autoscaler for node pools
  oke_node_pools = [for node_pool in values(module.oke_node_pools) : node_pool if node_pool.node_pool_autoscaler_enabled]

  depends_on = [module.oke, module.oke_node_pools]
}

resource "oci_identity_compartment" "oke_compartment" {
  compartment_id = var.compartment_ocid
  name           = "${local.app_name_normalized}-${local.deploy_id}"
  description    = "${local.app_name} ${var.oke_compartment_description} (Deployment ${local.deploy_id})"
  enable_delete  = true

  count = var.create_new_compartment_for_oke ? 1 : 0
}
locals {
  oke_compartment_ocid = var.create_new_compartment_for_oke ? oci_identity_compartment.oke_compartment.0.id : var.compartment_ocid
}

# OKE Subnets definitions
locals {
  subnets_oke = concat(local.subnets_oke_standard, local.subnet_vcn_native_pod_networking, local.subnet_bastion, local.subnet_fss_mount_targets)
  subnets_oke_standard = [
    {
      subnet_name                  = "oke_k8s_endpoint_subnet"
      cidr_block                   = lookup(local.network_cidrs, "ENDPOINT-REGIONAL-SUBNET-CIDR")
      display_name                 = "OKE K8s Endpoint subnet (${local.deploy_id})"
      dns_label                    = "okek8s${local.deploy_id}"
      prohibit_public_ip_on_vnic   = (var.cluster_endpoint_visibility == "Private") ? true : false
      prohibit_internet_ingress    = (var.cluster_endpoint_visibility == "Private") ? true : false
      route_table_id               = (var.cluster_endpoint_visibility == "Private") ? module.route_tables["private"].route_table_id : module.route_tables["public"].route_table_id
      alternative_route_table_name = null
      dhcp_options_id              = module.vcn.default_dhcp_options_id
      security_list_ids            = [module.security_lists["oke_endpoint_security_list"].security_list_id]
      extra_security_list_names    = anytrue([(var.extra_security_list_name_for_api_endpoint == ""), (var.extra_security_list_name_for_api_endpoint == null)]) ? [] : [var.extra_security_list_name_for_api_endpoint]
      ipv6cidr_block               = null
    },
    {
      subnet_name                  = "oke_nodes_subnet"
      cidr_block                   = lookup(local.network_cidrs, "NODES-REGIONAL-SUBNET-CIDR")
      display_name                 = "OKE Nodes subnet (${local.deploy_id})"
      dns_label                    = "okenodes${local.deploy_id}"
      prohibit_public_ip_on_vnic   = (var.cluster_workers_visibility == "Private") ? true : false
      prohibit_internet_ingress    = (var.cluster_workers_visibility == "Private") ? true : false
      route_table_id               = (var.cluster_workers_visibility == "Private") ? module.route_tables["private"].route_table_id : module.route_tables["public"].route_table_id
      alternative_route_table_name = null
      dhcp_options_id              = module.vcn.default_dhcp_options_id
      security_list_ids            = [module.security_lists["oke_nodes_security_list"].security_list_id]
      extra_security_list_names    = anytrue([(var.extra_security_list_name_for_nodes == ""), (var.extra_security_list_name_for_nodes == null)]) ? [] : [var.extra_security_list_name_for_nodes]
      ipv6cidr_block               = null
    },
    {
      subnet_name                  = "oke_lb_subnet"
      cidr_block                   = lookup(local.network_cidrs, "LB-REGIONAL-SUBNET-CIDR")
      display_name                 = "OKE LoadBalancers subnet (${local.deploy_id})"
      dns_label                    = "okelb${local.deploy_id}"
      prohibit_public_ip_on_vnic   = (var.cluster_load_balancer_visibility == "Private") ? true : false
      prohibit_internet_ingress    = (var.cluster_load_balancer_visibility == "Private") ? true : false
      route_table_id               = (var.cluster_load_balancer_visibility == "Private") ? module.route_tables["private"].route_table_id : module.route_tables["public"].route_table_id
      alternative_route_table_name = null
      dhcp_options_id              = module.vcn.default_dhcp_options_id
      security_list_ids            = [module.security_lists["oke_lb_security_list"].security_list_id]
      extra_security_list_names    = []
      ipv6cidr_block               = null
    }
  ]
  subnet_vcn_native_pod_networking = (var.create_pod_network_subnet || var.cluster_cni_type == "OCI_VCN_IP_NATIVE" || var.node_pool_cni_type_1 == "OCI_VCN_IP_NATIVE") ? [
    {
      subnet_name                  = "oke_pods_network_subnet"
      cidr_block                   = lookup(local.network_cidrs, "VCN-NATIVE-POD-NETWORKING-REGIONAL-SUBNET-CIDR") # e.g.: 10.20.128.0/17 (1,1) = 32766 usable IPs (10.20.128.0 - 10.20.255.255)
      display_name                 = "OKE PODs Network subnet (${local.deploy_id})"
      dns_label                    = "okenpn${local.deploy_id}"
      prohibit_public_ip_on_vnic   = (var.pods_network_visibility == "Private") ? true : false
      prohibit_internet_ingress    = (var.pods_network_visibility == "Private") ? true : false
      route_table_id               = (var.pods_network_visibility == "Private") ? module.route_tables["private"].route_table_id : module.route_tables["public"].route_table_id
      alternative_route_table_name = null
      dhcp_options_id              = module.vcn.default_dhcp_options_id
      security_list_ids            = [module.security_lists["oke_pod_network_security_list"].security_list_id]
      extra_security_list_names    = anytrue([(var.extra_security_list_name_for_vcn_native_pod_networking == ""), (var.extra_security_list_name_for_vcn_native_pod_networking == null)]) ? [] : [var.extra_security_list_name_for_vcn_native_pod_networking]
      ipv6cidr_block               = null
  }] : []
  subnet_bastion           = [] # 10.20.2.0/28 (12,32) = 15 usable IPs (10.20.2.0 - 10.20.2.15)
  subnet_fss_mount_targets = [] # 10.20.20.64/26 (10,81) = 62 usable IPs (10.20.20.64 - 10.20.20.255)
}

# OKE Route Tables definitions
locals {
  route_tables_oke = [
    {
      route_table_name = "private"
      display_name     = "OKE Private Route Table (${local.deploy_id})"
      route_rules = [
        {
          description       = "Traffic to the internet"
          destination       = lookup(local.network_cidrs, "ALL-CIDR")
          destination_type  = "CIDR_BLOCK"
          network_entity_id = module.gateways.nat_gateway_id
        },
        {
          description       = "Traffic to OCI services"
          destination       = lookup(data.oci_core_services.all_services_network.services[0], "cidr_block")
          destination_type  = "SERVICE_CIDR_BLOCK"
          network_entity_id = module.gateways.service_gateway_id
      }]

    },
    {
      route_table_name = "public"
      display_name     = "OKE Public Route Table (${local.deploy_id})"
      route_rules = [
        {
          description       = "Traffic to/from internet"
          destination       = lookup(local.network_cidrs, "ALL-CIDR")
          destination_type  = "CIDR_BLOCK"
          network_entity_id = module.gateways.internet_gateway_id
      }]
  }]
}

# OKE Security Lists definitions
locals {
  security_lists_oke = [
    {
      security_list_name = "oke_nodes_security_list"
      display_name       = "OKE Node Workers Security List (${local.deploy_id})"
      egress_security_rules = [
        {
          description      = "Allows communication from (or to) worker nodes"
          destination      = lookup(local.network_cidrs, "NODES-REGIONAL-SUBNET-CIDR")
          destination_type = "CIDR_BLOCK"
          protocol         = local.security_list_ports.all_protocols
          stateless        = false
          tcp_options      = { max = -1, min = -1, source_port_range = null }
          udp_options      = { max = -1, min = -1, source_port_range = null }
          icmp_options     = null
          }, {
          description      = "Allow worker nodes to communicate with pods on other worker nodes (when using VCN-native pod networking)"
          destination      = lookup(local.network_cidrs, "VCN-NATIVE-POD-NETWORKING-REGIONAL-SUBNET-CIDR")
          destination_type = "CIDR_BLOCK"
          protocol         = local.security_list_ports.all_protocols
          stateless        = false
          tcp_options      = { max = -1, min = -1, source_port_range = null }
          udp_options      = { max = -1, min = -1, source_port_range = null }
          icmp_options     = null
          }, {
          description      = "(optional) Allow worker nodes to communicate with internet"
          destination      = lookup(local.network_cidrs, "ALL-CIDR")
          destination_type = "CIDR_BLOCK"
          protocol         = local.security_list_ports.all_protocols
          stateless        = false
          tcp_options      = { max = -1, min = -1, source_port_range = null }
          udp_options      = { max = -1, min = -1, source_port_range = null }
          icmp_options     = null
          }, {
          description      = "Allow nodes to communicate with OKE to ensure correct start-up and continued functioning"
          destination      = lookup(data.oci_core_services.all_services_network.services[0], "cidr_block")
          destination_type = "SERVICE_CIDR_BLOCK"
          protocol         = local.security_list_ports.tcp_protocol_number
          stateless        = false
          tcp_options      = { max = -1, min = -1, source_port_range = null }
          udp_options      = { max = -1, min = -1, source_port_range = null }
          icmp_options     = null
          }, {
          description      = "ICMP Access from Kubernetes Control Plane"
          destination      = lookup(local.network_cidrs, "ALL-CIDR")
          destination_type = "CIDR_BLOCK"
          protocol         = local.security_list_ports.icmp_protocol_number
          stateless        = false
          tcp_options      = { max = -1, min = -1, source_port_range = null }
          udp_options      = { max = -1, min = -1, source_port_range = null }
          icmp_options     = { type = "3", code = "4" }
          }, {
          description      = "Access to Kubernetes API Endpoint"
          destination      = lookup(local.network_cidrs, "ENDPOINT-REGIONAL-SUBNET-CIDR")
          destination_type = "CIDR_BLOCK"
          protocol         = local.security_list_ports.tcp_protocol_number
          stateless        = false
          tcp_options      = { max = local.security_list_ports.k8s_api_endpoint_port_number, min = local.security_list_ports.k8s_api_endpoint_port_number, source_port_range = null }
          udp_options      = { max = -1, min = -1, source_port_range = null }
          icmp_options     = null
          }, {
          description      = "Kubernetes worker to control plane communication"
          destination      = lookup(local.network_cidrs, "ENDPOINT-REGIONAL-SUBNET-CIDR")
          destination_type = "CIDR_BLOCK"
          protocol         = local.security_list_ports.tcp_protocol_number
          stateless        = false
          tcp_options      = { max = local.security_list_ports.k8s_worker_to_control_plane_port_number, min = local.security_list_ports.k8s_worker_to_control_plane_port_number, source_port_range = null }
          udp_options      = { max = -1, min = -1, source_port_range = null }
          icmp_options     = null
          }, {
          description      = "Path discovery"
          destination      = lookup(local.network_cidrs, "ENDPOINT-REGIONAL-SUBNET-CIDR")
          destination_type = "CIDR_BLOCK"
          protocol         = local.security_list_ports.icmp_protocol_number
          stateless        = false
          tcp_options      = { max = -1, min = -1, source_port_range = null }
          udp_options      = { max = -1, min = -1, source_port_range = null }
          icmp_options     = { type = "3", code = "4" }
      }]
      ingress_security_rules = [
        {
          description  = "Allows communication from (or to) worker nodes"
          source       = lookup(local.network_cidrs, "NODES-REGIONAL-SUBNET-CIDR")
          source_type  = "CIDR_BLOCK"
          protocol     = local.security_list_ports.all_protocols
          stateless    = false
          tcp_options  = { max = -1, min = -1, source_port_range = null }
          udp_options  = { max = -1, min = -1, source_port_range = null }
          icmp_options = null
          }, {
          description  = "Allow pods on one worker node to communicate with pods on other worker nodes (when using VCN-native pod networking)"
          source       = lookup(local.network_cidrs, "VCN-NATIVE-POD-NETWORKING-REGIONAL-SUBNET-CIDR")
          source_type  = "CIDR_BLOCK"
          protocol     = local.security_list_ports.all_protocols
          stateless    = false
          tcp_options  = { max = -1, min = -1, source_port_range = null }
          udp_options  = { max = -1, min = -1, source_port_range = null }
          icmp_options = null
          }, {
          description  = "(optional) Allow inbound SSH traffic to worker nodes"
          source       = lookup(local.network_cidrs, (var.cluster_workers_visibility == "Private") ? "VCN-MAIN-CIDR" : "ALL-CIDR")
          source_type  = "CIDR_BLOCK"
          protocol     = local.security_list_ports.tcp_protocol_number
          stateless    = false
          tcp_options  = { max = local.security_list_ports.ssh_port_number, min = local.security_list_ports.ssh_port_number, source_port_range = null }
          udp_options  = { max = -1, min = -1, source_port_range = null }
          icmp_options = null
          }, {
          description  = "Allow control plane to communicate with worker nodes"
          source       = lookup(local.network_cidrs, "ENDPOINT-REGIONAL-SUBNET-CIDR")
          source_type  = "CIDR_BLOCK"
          protocol     = local.security_list_ports.tcp_protocol_number
          stateless    = false
          tcp_options  = { max = -1, min = -1, source_port_range = null }
          udp_options  = { max = -1, min = -1, source_port_range = null }
          icmp_options = null
          }, {
          description  = "Kubernetes API endpoint to worker node communication (when using VCN-native pod networking)"
          source       = lookup(local.network_cidrs, "ENDPOINT-REGIONAL-SUBNET-CIDR")
          source_type  = "CIDR_BLOCK"
          protocol     = local.security_list_ports.tcp_protocol_number
          stateless    = false
          tcp_options  = { max = local.security_list_ports.k8s_api_endpoint_to_worker_port_number, min = local.security_list_ports.k8s_api_endpoint_to_worker_port_number, source_port_range = null }
          udp_options  = { max = -1, min = -1, source_port_range = null }
          icmp_options = null
          }, {
          description  = "Path discovery - Kubernetes API Endpoint"
          source       = lookup(local.network_cidrs, "ENDPOINT-REGIONAL-SUBNET-CIDR")
          source_type  = "CIDR_BLOCK"
          protocol     = local.security_list_ports.icmp_protocol_number
          stateless    = false
          tcp_options  = { max = -1, min = -1, source_port_range = null }
          udp_options  = { max = -1, min = -1, source_port_range = null }
          icmp_options = { type = "3", code = "4" }
          }, {
          description  = "Path discovery"
          source       = lookup(local.network_cidrs, "ALL-CIDR")
          source_type  = "CIDR_BLOCK"
          protocol     = local.security_list_ports.icmp_protocol_number
          stateless    = false
          tcp_options  = { max = -1, min = -1, source_port_range = null }
          udp_options  = { max = -1, min = -1, source_port_range = null }
          icmp_options = { type = "3", code = "4" }
          }, {
          description  = "Load Balancer to Worker nodes node ports"
          source       = lookup(local.network_cidrs, "LB-REGIONAL-SUBNET-CIDR")
          source_type  = "CIDR_BLOCK"
          protocol     = local.security_list_ports.tcp_protocol_number # all_protocols
          stateless    = false
          tcp_options  = { max = 32767, min = 30000, source_port_range = null }
          udp_options  = { max = -1, min = -1, source_port_range = null }
          icmp_options = null
      }]
    },
    {
      security_list_name = "oke_lb_security_list"
      display_name       = "OKE Load Balancer Security List (${local.deploy_id})"
      egress_security_rules = [
        {
          description      = "Allow traffic to worker nodes"
          destination      = lookup(local.network_cidrs, "ALL-CIDR")
          destination_type = "CIDR_BLOCK"
          protocol         = local.security_list_ports.tcp_protocol_number # all_protocols
          stateless        = false
          tcp_options      = { max = 32767, min = 30000, source_port_range = null }
          udp_options      = { max = -1, min = -1, source_port_range = null }
          icmp_options     = null
      }]
      ingress_security_rules = [
        {
          description  = "Allow inbound traffic to Load Balancer"
          source       = lookup(local.network_cidrs, "ALL-CIDR")
          source_type  = "CIDR_BLOCK"
          protocol     = local.security_list_ports.tcp_protocol_number
          stateless    = false
          tcp_options  = { max = local.security_list_ports.https_port_number, min = local.security_list_ports.https_port_number, source_port_range = null }
          udp_options  = { max = -1, min = -1, source_port_range = null }
          icmp_options = null
      }]
    },
    {
      security_list_name = "oke_endpoint_security_list"
      display_name       = "OKE K8s API Endpoint Security List (${local.deploy_id})"
      egress_security_rules = [
        {
          description      = "Allow Kubernetes API Endpoint to communicate with OKE"
          destination      = lookup(data.oci_core_services.all_services_network.services[0], "cidr_block")
          destination_type = "SERVICE_CIDR_BLOCK"
          protocol         = local.security_list_ports.tcp_protocol_number
          stateless        = false
          tcp_options      = { max = local.security_list_ports.https_port_number, min = local.security_list_ports.https_port_number, source_port_range = null }
          udp_options      = { max = -1, min = -1, source_port_range = null }
          icmp_options     = null
          }, {
          description      = "Path discovery"
          destination      = lookup(local.network_cidrs, "NODES-REGIONAL-SUBNET-CIDR")
          destination_type = "CIDR_BLOCK"
          protocol         = local.security_list_ports.icmp_protocol_number
          stateless        = false
          tcp_options      = { max = -1, min = -1, source_port_range = null }
          udp_options      = { max = -1, min = -1, source_port_range = null }
          icmp_options     = { type = "3", code = "4" }
          }, {
          description      = "All traffic to worker nodes (when using flannel for pod networking)"
          destination      = lookup(local.network_cidrs, "NODES-REGIONAL-SUBNET-CIDR")
          destination_type = "CIDR_BLOCK"
          protocol         = local.security_list_ports.tcp_protocol_number
          stateless        = false
          tcp_options      = { max = -1, min = -1, source_port_range = null }
          udp_options      = { max = -1, min = -1, source_port_range = null }
          icmp_options     = null
          }, {
          description      = "Kubernetes API endpoint to pod communication (when using VCN-native pod networking)"
          destination      = lookup(local.network_cidrs, "VCN-NATIVE-POD-NETWORKING-REGIONAL-SUBNET-CIDR")
          destination_type = "CIDR_BLOCK"
          protocol         = local.security_list_ports.all_protocols
          stateless        = false
          tcp_options      = { max = -1, min = -1, source_port_range = null }
          udp_options      = { max = -1, min = -1, source_port_range = null }
          icmp_options     = null
          }, {
          description      = "Kubernetes API endpoint to worker node communication (when using VCN-native pod networking)"
          destination      = lookup(local.network_cidrs, "NODES-REGIONAL-SUBNET-CIDR")
          destination_type = "CIDR_BLOCK"
          protocol         = local.security_list_ports.tcp_protocol_number
          stateless        = false
          tcp_options      = { max = local.security_list_ports.k8s_api_endpoint_to_worker_port_number, min = local.security_list_ports.k8s_api_endpoint_to_worker_port_number, source_port_range = null }
          udp_options      = { max = -1, min = -1, source_port_range = null }
          icmp_options     = null
      }]
      ingress_security_rules = [
        {
          description  = "(optional) Client access to Kubernetes API endpoint"
          source       = lookup(local.network_cidrs, (var.cluster_endpoint_visibility == "Private") ? "VCN-MAIN-CIDR" : "ALL-CIDR")
          source_type  = "CIDR_BLOCK"
          protocol     = local.security_list_ports.tcp_protocol_number
          stateless    = false
          tcp_options  = { max = local.security_list_ports.k8s_api_endpoint_port_number, min = local.security_list_ports.k8s_api_endpoint_port_number, source_port_range = null }
          udp_options  = { max = -1, min = -1, source_port_range = null }
          icmp_options = null
          }, {
          description  = "Kubernetes worker to Kubernetes API endpoint communication"
          source       = lookup(local.network_cidrs, "NODES-REGIONAL-SUBNET-CIDR")
          source_type  = "CIDR_BLOCK"
          protocol     = local.security_list_ports.tcp_protocol_number
          stateless    = false
          tcp_options  = { max = local.security_list_ports.k8s_api_endpoint_port_number, min = local.security_list_ports.k8s_api_endpoint_port_number, source_port_range = null }
          udp_options  = { max = -1, min = -1, source_port_range = null }
          icmp_options = null
          }, {
          description  = "Kubernetes worker to control plane communication"
          source       = lookup(local.network_cidrs, "NODES-REGIONAL-SUBNET-CIDR")
          source_type  = "CIDR_BLOCK"
          protocol     = local.security_list_ports.tcp_protocol_number
          stateless    = false
          tcp_options  = { max = local.security_list_ports.k8s_worker_to_control_plane_port_number, min = local.security_list_ports.k8s_worker_to_control_plane_port_number, source_port_range = null }
          udp_options  = { max = -1, min = -1, source_port_range = null }
          icmp_options = null
          }, {
          description  = "Path discovery"
          source       = lookup(local.network_cidrs, "NODES-REGIONAL-SUBNET-CIDR")
          source_type  = "CIDR_BLOCK"
          protocol     = local.security_list_ports.icmp_protocol_number
          stateless    = false
          tcp_options  = { max = -1, min = -1, source_port_range = null }
          udp_options  = { max = -1, min = -1, source_port_range = null }
          icmp_options = { type = "3", code = "4" }
          }, {
          description  = "Pod to Kubernetes API endpoint communication (when using VCN-native pod networking)"
          source       = lookup(local.network_cidrs, "VCN-NATIVE-POD-NETWORKING-REGIONAL-SUBNET-CIDR")
          source_type  = "CIDR_BLOCK"
          protocol     = local.security_list_ports.tcp_protocol_number
          stateless    = false
          tcp_options  = { max = local.security_list_ports.k8s_api_endpoint_port_number, min = local.security_list_ports.k8s_api_endpoint_port_number, source_port_range = null }
          udp_options  = { max = -1, min = -1, source_port_range = null }
          icmp_options = null
          }, {
          description  = "Pod to control plane communication (when using VCN-native pod networking)"
          source       = lookup(local.network_cidrs, "VCN-NATIVE-POD-NETWORKING-REGIONAL-SUBNET-CIDR")
          source_type  = "CIDR_BLOCK"
          protocol     = local.security_list_ports.tcp_protocol_number
          stateless    = false
          tcp_options  = { max = local.security_list_ports.k8s_worker_to_control_plane_port_number, min = local.security_list_ports.k8s_worker_to_control_plane_port_number, source_port_range = null }
          udp_options  = { max = -1, min = -1, source_port_range = null }
          icmp_options = null
      }]
    },
    {
      security_list_name = "oke_pod_network_security_list"
      display_name       = "OKE VCN Native Pod Networking Security List (${local.deploy_id})"
      egress_security_rules = [
        {
          description      = "Allow pods to communicate with each other"
          destination      = lookup(local.network_cidrs, "VCN-NATIVE-POD-NETWORKING-REGIONAL-SUBNET-CIDR")
          destination_type = "CIDR_BLOCK"
          protocol         = local.security_list_ports.all_protocols
          stateless        = false
          tcp_options      = { max = -1, min = -1, source_port_range = null }
          udp_options      = { max = -1, min = -1, source_port_range = null }
          icmp_options     = null
          }, {
          description      = "Path discovery"
          destination      = lookup(data.oci_core_services.all_services_network.services[0], "cidr_block")
          destination_type = "SERVICE_CIDR_BLOCK"
          protocol         = local.security_list_ports.icmp_protocol_number
          stateless        = false
          tcp_options      = { max = -1, min = -1, source_port_range = null }
          udp_options      = { max = -1, min = -1, source_port_range = null }
          icmp_options     = { type = "3", code = "4" }
          }, {
          description      = "Allow worker nodes to communicate with OCI services"
          destination      = lookup(data.oci_core_services.all_services_network.services[0], "cidr_block")
          destination_type = "SERVICE_CIDR_BLOCK"
          protocol         = local.security_list_ports.tcp_protocol_number
          stateless        = false
          tcp_options      = { max = -1, min = -1, source_port_range = null }
          udp_options      = { max = -1, min = -1, source_port_range = null }
          icmp_options     = null
          }, {
          description      = "Allow Pods to communicate with Worker Nodes"
          destination      = lookup(local.network_cidrs, "NODES-REGIONAL-SUBNET-CIDR")
          destination_type = "CIDR_BLOCK"
          protocol         = local.security_list_ports.tcp_protocol_number
          stateless        = false
          tcp_options      = { max = -1, min = -1, source_port_range = null }
          udp_options      = { max = -1, min = -1, source_port_range = null }
          icmp_options     = null
          }, {
          description      = "Pod to Kubernetes API endpoint communication (when using VCN-native pod networking)"
          destination      = lookup(local.network_cidrs, "ENDPOINT-REGIONAL-SUBNET-CIDR")
          destination_type = "CIDR_BLOCK"
          protocol         = local.security_list_ports.tcp_protocol_number
          stateless        = false
          tcp_options      = { max = local.security_list_ports.k8s_api_endpoint_port_number, min = local.security_list_ports.k8s_api_endpoint_port_number, source_port_range = null }
          udp_options      = { max = -1, min = -1, source_port_range = null }
          icmp_options     = null
          }, {
          description      = "Pod to Kubernetes API endpoint communication (when using VCN-native pod networking)"
          destination      = lookup(local.network_cidrs, "ENDPOINT-REGIONAL-SUBNET-CIDR")
          destination_type = "CIDR_BLOCK"
          protocol         = local.security_list_ports.tcp_protocol_number
          stateless        = false
          tcp_options      = { max = local.security_list_ports.k8s_worker_to_control_plane_port_number, min = local.security_list_ports.k8s_worker_to_control_plane_port_number, source_port_range = null }
          udp_options      = { max = -1, min = -1, source_port_range = null }
          icmp_options     = null
          }, {
          description      = "(optional) Allow pods to communicate with internet"
          destination      = lookup(local.network_cidrs, "ALL-CIDR")
          destination_type = "CIDR_BLOCK"
          protocol         = local.security_list_ports.tcp_protocol_number
          stateless        = false
          tcp_options      = { max = local.security_list_ports.https_port_number, min = local.security_list_ports.https_port_number, source_port_range = null }
          udp_options      = { max = -1, min = -1, source_port_range = null }
          icmp_options     = null
      }]
      ingress_security_rules = [
        {
          description  = "Kubernetes API endpoint to pod communication (when using VCN-native pod networking)"
          source       = lookup(local.network_cidrs, "ENDPOINT-REGIONAL-SUBNET-CIDR")
          source_type  = "CIDR_BLOCK"
          protocol     = local.security_list_ports.all_protocols
          stateless    = false
          tcp_options  = { max = -1, min = -1, source_port_range = null }
          udp_options  = { max = -1, min = -1, source_port_range = null }
          icmp_options = null
          }, {
          description  = "Allow pods on one worker node to communicate with pods on other worker nodes"
          source       = lookup(local.network_cidrs, "NODES-REGIONAL-SUBNET-CIDR")
          source_type  = "CIDR_BLOCK"
          protocol     = local.security_list_ports.all_protocols
          stateless    = false
          tcp_options  = { max = -1, min = -1, source_port_range = null }
          udp_options  = { max = -1, min = -1, source_port_range = null }
          icmp_options = null
          }, {
          description  = "Allow pods to communicate with each other"
          source       = lookup(local.network_cidrs, "VCN-NATIVE-POD-NETWORKING-REGIONAL-SUBNET-CIDR")
          source_type  = "CIDR_BLOCK"
          protocol     = local.security_list_ports.all_protocols
          stateless    = false
          tcp_options  = { max = -1, min = -1, source_port_range = null }
          udp_options  = { max = -1, min = -1, source_port_range = null }
          icmp_options = null
      }]
    }
  ]
  security_list_ports = {
    http_port_number                        = 80
    https_port_number                       = 443
    k8s_api_endpoint_port_number            = 6443
    k8s_api_endpoint_to_worker_port_number  = 10250
    k8s_worker_to_control_plane_port_number = 12250
    ssh_port_number                         = 22
    tcp_protocol_number                     = "6"
    icmp_protocol_number                    = "1"
    all_protocols                           = "all"
  }
}

# Network locals
locals {
  cni_type = (var.cluster_cni_type == "OCI_VCN_IP_NATIVE" || var.node_pool_cni_type_1 == "OCI_VCN_IP_NATIVE") ? "OCI_VCN_IP_NATIVE" : "FLANNEL_OVERLAY"
}


# ── variables.tf ────────────────────────────────────
# Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

################################################################################
# OCI Provider Variables
################################################################################
variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "region" {}
variable "user_ocid" {
  default = ""
}
variable "fingerprint" {
  default = ""
}
variable "private_key_path" {
  default = ""
}
variable "home_region" {
  default = ""
}


################################################################################
# App Name to identify deployment. Used for naming resources.
################################################################################
variable "app_name" {
  default     = "K8s App"
  type = string
  description = "Application name. Will be used as prefix to identify resources, such as OKE, VCN, ATP, and others"
}
variable "tag_values" {
  type = map(any)
  default = { "freeformTags" = {
    "Environment" = "Development",  # e.g.: Demo, Sandbox, Development, QA, Stage, ...
    "DeploymentType" = "generic" }, # e.g.: App Type 1, App Type 2, Red, Purple, ...
  "definedTags" = {} }
  description = "Use Tagging to add metadata to resources. All resources created by this stack will be tagged with the selected tag values."
}

################################################################################
# Variables: OCI Networking
################################################################################
## VCN
variable "create_new_vcn" {
  default     = true
  description = "Creates a new Virtual Cloud Network (VCN). If false, the VCN must be provided in the variable 'existent_vcn_ocid'."
}
variable "existent_vcn_ocid" {
  default     = ""
  description = "Using existent Virtual Cloud Network (VCN) OCID."
}
variable "existent_vcn_compartment_ocid" {
  default     = ""
  description = "Compartment OCID for existent Virtual Cloud Network (VCN)."
}
variable "vcn_cidr_blocks" {
  default     = "10.20.0.0/16"
  description = "IPv4 CIDR Blocks for the Virtual Cloud Network (VCN). If use more than one block, separate them with comma. e.g.: 10.20.0.0/16,10.80.0.0/16. If you plan to peer this VCN with another VCN, the VCNs must not have overlapping CIDRs."
}
variable "is_ipv6enabled" {
  default     = false
  description = "Whether IPv6 is enabled for the Virtual Cloud Network (VCN)."
}
variable "ipv6private_cidr_blocks" {
  default     = []
  description = "The list of one or more ULA or Private IPv6 CIDR blocks for the Virtual Cloud Network (VCN)."
}
## Subnets
variable "create_subnets" {
  default     = true
  description = "Create subnets for OKE: Endpoint, Nodes, Load Balancers. If CNI Type OCI_VCN_IP_NATIVE, also creates the PODs VCN. If FSS Mount Targets, also creates the FSS Mount Targets Subnet"
}
variable "create_pod_network_subnet" {
  default     = false
  description = "Create PODs Network subnet for OKE. To be used with CNI Type OCI_VCN_IP_NATIVE"
}
variable "existent_oke_k8s_endpoint_subnet_ocid" {
  default     = ""
  description = "The OCID of the subnet where the Kubernetes cluster endpoint will be hosted"
}
variable "existent_oke_nodes_subnet_ocid" {
  default     = ""
  description = "The OCID of the subnet where the Kubernetes worker nodes will be hosted"
}
variable "existent_oke_load_balancer_subnet_ocid" {
  default     = ""
  description = "The OCID of the subnet where the Kubernetes load balancers will be hosted"
}
variable "existent_oke_vcn_native_pod_networking_subnet_ocid" {
  default     = ""
  description = "The OCID of the subnet where the Kubernetes VCN Native Pod Networking will be hosted"
}
variable "existent_oke_fss_mount_targets_subnet_ocid" {
  default     = ""
  description = "The OCID of the subnet where the Kubernetes FSS mount targets will be hosted"
}
# variable "existent_apigw_fn_subnet_ocid" {
#   default     = ""
#   description = "The OCID of the subnet where the API Gateway and Functions will be hosted"
# }
variable "extra_subnets" {
  default     = []
  description = "Extra subnets to be created."
}
variable "extra_route_tables" {
  default     = []
  description = "Extra route tables to be created."
}
variable "extra_security_lists" {
  default     = []
  description = "Extra security lists to be created."
}
variable "extra_security_list_name_for_api_endpoint" {
  default     = null
  description = "Extra security list name previosly created to be used by the K8s API Endpoint Subnet."
}
variable "extra_security_list_name_for_nodes" {
  default     = null
  description = "Extra security list name previosly created to be used by the Nodes Subnet."
}
variable "extra_security_list_name_for_vcn_native_pod_networking" {
  default     = null
  description = "Extra security list name previosly created to be used by the VCN Native Pod Networking Subnet."
}

################################################################################
# Variables: OKE Network
################################################################################
# OKE Network Visibility (Workers, Endpoint and Load Balancers)
variable "cluster_workers_visibility" {
  default     = "Private"
  description = "The Kubernetes worker nodes that are created will be hosted in public or private subnet(s)"

  validation {
    condition     = var.cluster_workers_visibility == "Private" || var.cluster_workers_visibility == "Public"
    error_message = "Sorry, but cluster visibility can only be Private or Public."
  }
}
variable "cluster_endpoint_visibility" {
  default     = "Public"
  description = "The Kubernetes cluster that is created will be hosted on a public subnet with a public IP address auto-assigned or on a private subnet. If Private, additional configuration will be necessary to run kubectl commands"

  validation {
    condition     = var.cluster_endpoint_visibility == "Private" || var.cluster_endpoint_visibility == "Public"
    error_message = "Sorry, but cluster endpoint visibility can only be Private or Public."
  }
}
variable "cluster_load_balancer_visibility" {
  default     = "Public"
  description = "The Load Balancer that is created will be hosted on a public subnet with a public IP address auto-assigned or on a private subnet. This affects the Kubernetes services, ingress controller and other load balancers resources"

  validation {
    condition     = var.cluster_load_balancer_visibility == "Private" || var.cluster_load_balancer_visibility == "Public"
    error_message = "Sorry, but cluster load balancer visibility can only be Private or Public."
  }
}
variable "pods_network_visibility" {
  default     = "Private"
  description = "The PODs that are created will be hosted on a public subnet with a public IP address auto-assigned or on a private subnet. This affects the Kubernetes services and pods"

  validation {
    condition     = var.pods_network_visibility == "Private" || var.pods_network_visibility == "Public"
    error_message = "Sorry, but PODs Network visibility can only be Private or Public."
  }
}

################################################################################
# Variables: OKE Cluster
################################################################################
## OKE Cluster Details
variable "create_new_oke_cluster" {
  default     = true
  description = "Creates a new OKE cluster, node pool and network resources"
}
variable "existent_oke_cluster_id" {
  default     = ""
  description = "Using existent OKE Cluster. Only the application and services will be provisioned. If select cluster autoscaler feature, you need to get the node pool id and enter when required"
}
variable "cluster_type" {
  default     = "ENHANCED_CLUSTER"
  description = "The type of OKE cluster to create. Valid values are: BASIC_CLUSTER or ENHANCED_CLUSTER"

  validation {
    condition     = var.cluster_type == "BASIC_CLUSTER" || var.cluster_type == "ENHANCED_CLUSTER"
    error_message = "Sorry, but cluster visibility can only be BASIC_CLUSTER or ENHANCED_CLUSTER."
  }
}
variable "create_new_compartment_for_oke" {
  default     = false
  description = "Creates new compartment for OKE Nodes and OCI Services deployed.  NOTE: The creation of the compartment increases the deployment time by at least 3 minutes, and can increase by 15 minutes when destroying"
}
variable "oke_compartment_description" {
  default = "Compartment for OKE, Nodes and Services"
}
variable "cluster_cni_type" {
  default     = "FLANNEL_OVERLAY"
  description = "The CNI type to use for the cluster. Valid values are: FLANNEL_OVERLAY or OCI_VCN_IP_NATIVE"

  validation {
    condition     = var.cluster_cni_type == "FLANNEL_OVERLAY" || var.cluster_cni_type == "OCI_VCN_IP_NATIVE"
    error_message = "Sorry, but OKE currently only supports FLANNEL_OVERLAY or OCI_VCN_IP_NATIVE CNI types."
  }
}


# OIDC
variable "oke_cluster_oidc_discovery" {
  default     = false
  description = "Enable OpenID Connect discovery in the cluster"
}

## OKE Encryption details
variable "use_encryption_from_oci_vault" {
  default     = false
  description = "By default, Oracle manages the keys that encrypts Kubernetes Secrets at Rest in Etcd, but you can choose a key from a vault that you have access to, if you want greater control over the key's lifecycle and how it's used"
}
variable "create_new_encryption_key" {
  default     = false
  description = "Creates new vault and key on OCI Vault/Key Management/KMS and assign to boot volume of the worker nodes"
}
variable "existent_encryption_key_id" {
  default     = ""
  description = "Use an existent master encryption key to encrypt boot volume and object storage bucket. NOTE: If the key resides in a different compartment or in a different tenancy, make sure you have the proper policies to access, or the provision of the worker nodes will fail"
}
variable "create_vault_policies_for_group" {
  default     = false
  description = "Creates policies to allow the user applying the stack to manage vault and keys. If you are on the Administrators group or already have the policies for a compartment, this policy is not needed. If you do not have access to allow the policy, ask your administrator to include it for you"
}
variable "user_admin_group_for_vault_policy" {
  default     = "Administrators"
  description = "User Identity Group to allow manage vault and keys. The user running the Terraform scripts or Applying the ORM Stack need to be on this group"
}

## OKE Autoscaler
variable "node_pool_autoscaler_enabled_1" {
  default     = true
  description = "Enable Cluster Autoscaler on the node pool (pool1). Node pools will auto scale based on the resources usage and will add or remove nodes (Compute) based on the min and max number of nodes"
}
variable "node_pool_initial_num_worker_nodes_1" {
  default     = 2 #3
  description = "The number of worker nodes in the node pool. If enable Cluster Autoscaler, will assume the minimum number of nodes on the node pool to be scheduled by the Kubernetes (pool1)"
}
variable "node_pool_max_num_worker_nodes_1" {
  default     = 2 #10
  description = "Maximum number of nodes on the node pool to be scheduled by the Kubernetes (pool1)"
}
variable "existent_oke_nodepool_id_for_autoscaler_1" {
  default     = ""
  description = "Nodepool Id of the existent OKE to use with Cluster Autoscaler (pool1)"
}

################################################################################
# Variables: OKE Node Pool 1
################################################################################
## OKE Node Pool Details
variable "k8s_version" {
  default     = "Latest" # "v1.29.1"
  description = "Kubernetes version installed on your Control Plane and worker nodes. If not version select, will use the latest available."
}
### Node Pool 1
variable "node_pool_name_1" {
  default     = "pool1"
  description = "Name of the node pool 1"
}
variable "extra_initial_node_labels_1" {
  default     = []
  description = "Extra initial node labels to be added to the node pool 1"
}
variable "node_pool_cni_type_1" {
  default     = "FLANNEL_OVERLAY"
  description = "The CNI type to use for the cluster. Valid values are: FLANNEL_OVERLAY or OCI_VCN_IP_NATIVE"

  validation {
    condition     = var.node_pool_cni_type_1 == "FLANNEL_OVERLAY" || var.node_pool_cni_type_1 == "OCI_VCN_IP_NATIVE"
    error_message = "Sorry, but OKE currently only supports FLANNEL_OVERLAY or OCI_VCN_IP_NATIVE CNI types."
  }
}

#### ocpus and memory are only used if flex shape is selected
variable "node_pool_instance_shape_1" {
  type = map(any)
  default = {
    "instanceShape" = "VM.Standard.E4.Flex"
    "ocpus"         = 2
    "memory"        = 16
  }
  description = "A shape is a template that determines the number of OCPUs, amount of memory, and other resources allocated to a newly created instance for the Worker Node. Select at least 2 OCPUs and 16GB of memory if using Flex shapes"
}
variable "node_pool_shape_specific_ad_1" {
  description = "The number of the AD to get the shape for the node pool"
  type        = number
  default     = 0

  validation {
    condition     = var.node_pool_shape_specific_ad_1 >= 0 && var.node_pool_shape_specific_ad_1 <= 3
    error_message = "Invalid AD number, should be 0 to get all ADs or 1, 2 or 3 to be a specific AD."
  }
}
variable "node_pool_boot_volume_size_in_gbs_1" {
  default     = "60"
  description = "Specify a custom boot volume size (in GB)"
}
variable "image_operating_system_1" {
  default     = "Oracle Linux"
  description = "The OS/image installed on all nodes in the node pool."
}
variable "image_operating_system_version_1" {
  default     = "8"
  description = "The OS/image version installed on all nodes in the node pool."
}
variable "node_pool_oke_init_params_1" {
  type        = string
  default     = ""
  description = "OKE Init params"
}
variable "node_pool_cloud_init_parts_1" {
  type = list(object({
    content_type = string
    content      = string
    filename     = string
  }))
  default     = []
  description = "Node Pool nodes Cloud init parts"
}
variable "generate_public_ssh_key" {
  default = true
}
variable "public_ssh_key" {
  default     = ""
  description = "In order to access your private nodes with a public SSH key you will need to set up a bastion host (a.k.a. jump box). If using public nodes, bastion is not needed. Left blank to not import keys."
}
################################################################################
# Variables: OKE Extra Node Pools
################################################################################
variable "extra_node_pools" {
  default     = []
  description = "Extra node pools to be added to the cluster"
}

################################################################################
# Variables: Dynamic Group and Policies for OKE
################################################################################
# Create Dynamic Group and Policies
variable "create_dynamic_group_for_nodes_in_compartment" {
  default     = true
  description = "Creates dynamic group of Nodes in the compartment. Note: You need to have proper rights on the Tenancy. If you only have rights in a compartment, uncheck and ask you administrator to create the Dynamic Group for you"
}
variable "existent_dynamic_group_for_nodes_in_compartment" {
  default     = ""
  description = "Enter previous created Dynamic Group for the policies"
}
variable "create_compartment_policies" {
  default     = true
  description = "Creates policies that will reside on the compartment. e.g.: Policies to support Cluster Autoscaler, OCI Logging datasource on Grafana"
}
variable "create_tenancy_policies" {
  default     = false
  description = "Creates policies that need to reside on the tenancy. e.g.: Policies to support OCI Metrics datasource on Grafana"
}

# ── outputs.tf ────────────────────────────────────
# Copyright (c) 2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

# Deployment outputs
output "stack_version" {
  value = file("${path.module}/VERSION")
}
output "deploy_id" {
  value = local.deploy_id
}

# OKE Outputs
output "comments" {
  value = module.oke.comments
}
output "deployed_oke_kubernetes_version" {
  value = module.oke.deployed_oke_kubernetes_version
}
output "deployed_to_region" {
  value = module.oke.deployed_to_region
}
output "cluster_endpoint_visibility" {
  description = "The visibility of the cluster endpoint."
  value       = var.cluster_endpoint_visibility
}
output "kubeconfig" {
  value     = module.oke.kubeconfig
  sensitive = true
}
output "kubeconfig_for_kubectl" {
  value       = module.oke.kubeconfig_for_kubectl
  description = "If using Terraform locally, this sets KUBECONFIG environment variable to run kubectl locally"
}
output "oke_cluster_ocid" {
  value = module.oke.oke_cluster_ocid
}
output "oke_node_pools" {
  value = module.oke_node_pools
}
output "subnets" {
  value = module.subnets
}

output "dev" {
  value = module.oke.dev
}
### Important Security Notice ###
# The private key generated by this resource will be stored unencrypted in your Terraform state file. 
# Use of this resource for production deployments is not recommended. 
# Instead, generate a private key file outside of Terraform and distribute it securely to the system where Terraform will be run.
output "generated_private_key_pem" {
  value     = var.generate_public_ssh_key ? tls_private_key.oke_worker_node_ssh_key.private_key_pem : "No Keys Auto Generated"
  sensitive = true
}


output "cluster_type_value" {
  value = var.cluster_type
}


# ── providers.tf ────────────────────────────────────
# Copyright (c) 2023, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#

provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  region       = var.region
}

provider "oci" {
  alias        = "home_region"
  tenancy_ocid = var.tenancy_ocid
  region       = lookup(data.oci_identity_regions.home_region.regions[0], "name")

  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
}

# New configuration to avoid Terraform Kubernetes provider interpolation. https://registry.terraform.io/providers/hashicorp/kubernetes/2.2.0/docs#stacking-with-managed-kubernetes-cluster-resources
# Currently need to uncheck to refresh (--refresh=false) when destroying or else the terraform destroy will fail

# https://docs.cloud.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengdownloadkubeconfigfile.htm#notes
provider "kubernetes" {
  host                   = local.cluster_endpoint
  cluster_ca_certificate = local.cluster_ca_certificate
  insecure               = local.external_private_endpoint
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["ce", "cluster", "generate-token", "--cluster-id", local.cluster_id, "--region", local.cluster_region]
    command     = "oci"
  }
}

# https://docs.cloud.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengdownloadkubeconfigfile.htm#notes
provider "helm" {
  kubernetes {
    host                   = local.cluster_endpoint
    cluster_ca_certificate = local.cluster_ca_certificate
    insecure               = local.external_private_endpoint
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["ce", "cluster", "generate-token", "--cluster-id", local.cluster_id, "--region", local.cluster_region]
      command     = "oci"
    }
  }
}

locals {
  cluster_endpoint = (var.cluster_endpoint_visibility == "Private") ? (
    "https://${module.oke.orm_private_endpoint_oke_api_ip_address}:6443") : (
  yamldecode(module.oke.kubeconfig)["clusters"][0]["cluster"]["server"])
  external_private_endpoint = (var.cluster_endpoint_visibility == "Private") ? true : false
  cluster_ca_certificate    = base64decode(yamldecode(module.oke.kubeconfig)["clusters"][0]["cluster"]["certificate-authority-data"])
  cluster_id                = yamldecode(module.oke.kubeconfig)["users"][0]["user"]["exec"]["args"][4]
  cluster_region            = yamldecode(module.oke.kubeconfig)["users"][0]["user"]["exec"]["args"][6]
}

# Gets home and current regions
data "oci_identity_tenancy" "tenant_details" {
  tenancy_id = var.tenancy_ocid
}

data "oci_identity_regions" "home_region" {
  filter {
    name   = "key"
    values = [data.oci_identity_tenancy.tenant_details.home_region_key]
  }
}


# ── versions.tf ────────────────────────────────────
# Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

terraform {
  required_version = ">= 1.5" #">= 1.1"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 6" #"~> 4, < 5"
      # https://registry.terraform.io/providers/oracle/oci/
      configuration_aliases = [oci.home_region]
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.32" #"~> 2"
      # https://registry.terraform.io/providers/hashicorp/kubernetes/
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.15" #"~> 2"
      # https://registry.terraform.io/providers/hashicorp/helm/
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4" # "~> 4"
      # https://registry.terraform.io/providers/hashicorp/tls/
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5" #"~> 2"
      # https://registry.terraform.io/providers/hashicorp/local/
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6" #"~> 3"
      # https://registry.terraform.io/providers/hashicorp/random/
    }
  }
}


# ── cluster-tools.tf ────────────────────────────────────
# Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

################################################################################
# Module: Kubernetes Cluster Tools
################################################################################
module "cluster-tools" {
  source = "./modules/cluster-tools"

  # Oracle Cloud Infrastructure Tenancy and Compartment OCID
  tenancy_ocid = var.tenancy_ocid
  # compartment_ocid = var.compartment_ocid
  region = var.region

  # Deployment Tags + Freeform Tags + Defined Tags
  oci_tag_values = local.oci_tag_values

  # Cluster Tools
  ## Namespace
  cluster_tools_namespace = "cluster-tools"

  ## Ingress Controller
  ingress_nginx_enabled                = var.ingress_nginx_enabled
  ingress_load_balancer_shape          = var.ingress_load_balancer_shape
  ingress_load_balancer_shape_flex_min = var.ingress_load_balancer_shape_flex_min
  ingress_load_balancer_shape_flex_max = var.ingress_load_balancer_shape_flex_max

  ## Ingress
  ingress_hosts                = var.ingress_hosts
  ingress_tls                  = var.ingress_tls
  ingress_cluster_issuer       = var.ingress_cluster_issuer
  ingress_email_issuer         = var.ingress_email_issuer
  ingress_hosts_include_nip_io = var.ingress_hosts_include_nip_io
  nip_io_domain                = var.nip_io_domain

  ## Cert Manager
  cert_manager_enabled = var.cert_manager_enabled

  ## Metrics Server
  metrics_server_enabled = var.metrics_server_enabled

  ## Prometheus
  prometheus_enabled = var.prometheus_enabled

  ## Grafana
  grafana_enabled = var.grafana_enabled

  depends_on = [module.oke, module.oke_node_pools, module.oke_cluster_autoscaler]
}

# Kubernetes Cluster Tools
## IngressController/LoadBalancer
variable "ingress_nginx_enabled" {
  default     = false
  description = "Enable Ingress Nginx for Kubernetes Services (This option provision a Load Balancer)"
}
variable "ingress_load_balancer_shape" {
  default     = "flexible" # Flexible, 10Mbps, 100Mbps, 400Mbps or 8000Mps
  description = "Shape that will be included on the Ingress annotation for the OCI Load Balancer creation"
}
variable "ingress_load_balancer_shape_flex_min" {
  default     = "10"
  description = "Enter the minimum size of the flexible shape."
}
variable "ingress_load_balancer_shape_flex_max" {
  default     = "100" # From 10 to 8000. Cannot be lower than ingress_load_balancer_shape_flex_min
  description = "Enter the maximum size of the flexible shape (Should be bigger than minimum size). The maximum service limit is set by your tenancy limits."
}
## Ingresses
variable "ingress_hosts" {
  default     = ""
  description = "Enter a valid full qualified domain name (FQDN). You will need to map the domain name to the EXTERNAL-IP address on your DNS provider (DNS Registry type - A). If you have multiple domain names, include separated by comma. e.g.: mushop.example.com,catshop.com"
}
variable "ingress_hosts_include_nip_io" {
  default     = true
  description = "Include app_name.HEXXX.nip.io on the ingress hosts. e.g.: mushop.HEXXX.nip.io"
}
variable "nip_io_domain" {
  default     = "nip.io"
  description = "Dynamic wildcard DNS for the application hostname. Should support hex notation. e.g.: nip.io"
}
variable "ingress_tls" {
  default     = false
  description = "If enabled, will generate SSL certificates to enable HTTPS for the ingress using the Certificate Issuer"
}
variable "ingress_cluster_issuer" {
  default     = "letsencrypt-prod"
  description = "Certificate issuer type. Currently supports the free Let's Encrypt and Self-Signed. Only *letsencrypt-prod* generates valid certificates"
}
variable "ingress_email_issuer" {
  default     = "no-reply@example.cloud"
  description = "You must replace this email address with your own. The certificate provider will use this to contact you about expiring certificates, and issues related to your account."
}

## Cert Manager
variable "cert_manager_enabled" {
  default     = false
  description = "Enable x509 Certificate Management"
}

## Metrics Server
variable "metrics_server_enabled" {
  default     = true
  description = "Enable Metrics Server for Metrics, HPA, VPA and Cluster Autoscaler"
}

## Prometheus
variable "prometheus_enabled" {
  default     = false
  description = "Enable Prometheus"
}

## Grafana
variable "grafana_enabled" {
  default     = false
  description = "Enable Grafana Dashboards. Includes example dashboards and Prometheus, OCI Logging and OCI Metrics datasources"
}

# Cluster Tools Outputs
## grafana
output "grafana_admin_password" {
  value     = module.cluster-tools.grafana_admin_password
  sensitive = true
}

## Ingress Controller
locals {
  app_domain   = module.cluster-tools.ingress_controller_load_balancer_hostname
  url_protocol = module.cluster-tools.url_protocol
}

output "grafana_url" {
  value       = (var.grafana_enabled && var.ingress_nginx_enabled) ? format("${local.url_protocol}://%s/grafana", local.app_domain) : null
  description = "Grafana Dashboards URL"
}

output "app_url" {
  value       = (var.ingress_nginx_enabled) ? format("${local.url_protocol}://%s", local.app_domain) : null
  description = "Application URL"
}


# ── datasources.tf ────────────────────────────────────
# Copyright (c) 2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

# # Gets home and current regions
# data "oci_identity_tenancy" "tenant_details" {
#   tenancy_id = var.tenancy_ocid

#   provider = oci.current_region
# }

# data "oci_identity_regions" "home_region" {
#   filter {
#     name   = "key"
#     values = [data.oci_identity_tenancy.tenant_details.home_region_key]
#   }

#   provider = oci.current_region
# }

# Available OCI Services
data "oci_core_services" "all_services_network" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}


# ── defaults.tf ────────────────────────────────────
# Copyright (c) 2022-2023 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

# File Version: 0.1.0

# Dependencies:
#   - terraform-oci-networking module

################################################################################
# If you have extra configurations to add, you can add them here.
# It's supported to include:
#   - Extra Node Pools and their configurations
#   - Extra subnets
#   - Extra route tables and security lists
################################################################################

################################################################################
# Deployment Defaults
################################################################################
locals {
  deploy_id   = random_string.deploy_id.result
  deploy_tags = { "DeploymentID" = local.deploy_id, "AppName" = local.app_name, "Quickstart" = "terraform-oci-oke-quickstart", "OKEclusterName" = "${local.app_name} (${local.deploy_id})" }
  oci_tag_values = {
    "freeformTags" = merge(var.tag_values.freeformTags, local.deploy_tags),
    "definedTags"  = var.tag_values.definedTags
  }
  app_name            = var.app_name
  app_name_normalized = substr(replace(lower(local.app_name), " ", "-"), 0, 6)
  app_name_for_dns    = substr(lower(replace(local.app_name, "/\\W|_|\\s/", "")), 0, 6)
}

resource "random_string" "deploy_id" {
  length  = 4
  special = false
}

################################################################################
# Required locals for the oci-networking and oke modules
################################################################################
locals {
  node_pools                    = concat(local.node_pool_1, local.extra_node_pools, var.extra_node_pools)
  create_new_vcn                = (var.create_new_oke_cluster && var.create_new_vcn) ? true : false
  vcn_display_name              = "[${local.app_name}] VCN for OKE (${local.deploy_id})"
  create_subnets                = (var.create_subnets) ? true : false
  subnets                       = concat(local.subnets_oke, local.extra_subnets, var.extra_subnets)
  route_tables                  = concat(local.route_tables_oke, var.extra_route_tables)
  security_lists                = concat(local.security_lists_oke, var.extra_security_lists)
  resolved_vcn_compartment_ocid = (var.create_new_compartment_for_oke ? local.oke_compartment_ocid : var.compartment_ocid)
  pre_vcn_cidr_blocks           = split(",", var.vcn_cidr_blocks)
  vcn_cidr_blocks               = contains(module.vcn.cidr_blocks, local.pre_vcn_cidr_blocks[0]) ? distinct(concat([local.pre_vcn_cidr_blocks[0]], module.vcn.cidr_blocks)) : module.vcn.cidr_blocks
  network_cidrs = {
    VCN-MAIN-CIDR                                  = local.vcn_cidr_blocks[0]                     # e.g.: "10.20.0.0/16" = 65536 usable IPs
    ENDPOINT-REGIONAL-SUBNET-CIDR                  = cidrsubnet(local.vcn_cidr_blocks[0], 12, 0)  # e.g.: "10.20.0.0/28" = 15 usable IPs
    NODES-REGIONAL-SUBNET-CIDR                     = cidrsubnet(local.vcn_cidr_blocks[0], 6, 3)   # e.g.: "10.20.12.0/22" = 1021 usable IPs (10.20.12.0 - 10.20.15.255)
    LB-REGIONAL-SUBNET-CIDR                        = cidrsubnet(local.vcn_cidr_blocks[0], 6, 4)   # e.g.: "10.20.16.0/22" = 1021 usable IPs (10.20.16.0 - 10.20.19.255)
    FSS-MOUNT-TARGETS-REGIONAL-SUBNET-CIDR         = cidrsubnet(local.vcn_cidr_blocks[0], 10, 81) # e.g.: "10.20.20.64/26" = 62 usable IPs (10.20.20.64 - 10.20.20.255)
    APIGW-FN-REGIONAL-SUBNET-CIDR                  = cidrsubnet(local.vcn_cidr_blocks[0], 8, 30)  # e.g.: "10.20.30.0/24" = 254 usable IPs (10.20.30.0 - 10.20.30.255)
    VCN-NATIVE-POD-NETWORKING-REGIONAL-SUBNET-CIDR = cidrsubnet(local.vcn_cidr_blocks[0], 1, 1)   # e.g.: "10.20.128.0/17" = 32766 usable IPs (10.20.128.0 - 10.20.255.255)
    BASTION-REGIONAL-SUBNET-CIDR                   = cidrsubnet(local.vcn_cidr_blocks[0], 12, 32) # e.g.: "10.20.2.0/28" = 15 usable IPs (10.20.2.0 - 10.20.2.15)
    PODS-CIDR                                      = "10.244.0.0/16"
    KUBERNETES-SERVICE-CIDR                        = "10.96.0.0/16"
    ALL-CIDR                                       = "0.0.0.0/0"
  }
}

################################################################################
# Extra OKE node pools
# Example commented out below
################################################################################
locals {
  extra_node_pools = [
    # {
    #   node_pool_name                            = "GPU" # Must be unique
    #   node_pool_autoscaler_enabled            = false
    #   node_pool_min_nodes                       = 1
    #   node_pool_max_nodes                       = 2
    #   node_k8s_version                          = var.k8s_version
    #   node_pool_shape                           = "BM.GPU.A10.4"
    #   node_pool_shape_specific_ad                = 3 # Optional, if not provided or set = 0, will be randomly assigned
    #   node_pool_node_shape_config_ocpus         = 1
    #   node_pool_node_shape_config_memory_in_gbs = 1
    #   node_pool_boot_volume_size_in_gbs         = "100"
    #   existent_oke_nodepool_id_for_autoscaler   = null
    #   node_pool_alternative_subnet              = null # Optional, name of previously created subnet
    #   image_operating_system                    = null
    #   image_operating_system_version            = null
    #   extra_initial_node_labels                 = [{ key = "app.pixel/gpu", value = "true" }]
    #   cni_type                                  = "FLANNEL_OVERLAY" # "FLANNEL_OVERLAY" or "OCI_VCN_IP_NATIVE"
    # },
  ]
}

locals {
  extra_subnets = [
    # {
    #   subnet_name                = "opensearch_subnet"
    #   cidr_block                 = cidrsubnet(local.vcn_cidr_blocks[0], 8, 35) # e.g.: "10.20.35.0/24" = 254 usable IPs (10.20.35.0 - 10.20.35.255)
    #   display_name               = "OCI OpenSearch Service subnet (${local.deploy_id})" # If null, is autogenerated
    #   dns_label                  = "opensearch${local.deploy_id}" # If null, disable dns label
    #   prohibit_public_ip_on_vnic = false
    #   prohibit_internet_ingress  = false
    #   route_table_id             = module.route_tables["public"].route_table_id # If null, the VCN's default route table is used
    #   alternative_route_table_name    = null # Optional, Name of the previously created route table
    #   dhcp_options_id            = module.vcn.default_dhcp_options_id # If null, the VCN's default set of DHCP options is used
    #   security_list_ids          = [module.security_lists["opensearch_security_list"].security_list_id] # If null, the VCN's default security list is used
    #   extra_security_list_names  = [] # Optional, Names of the previously created security lists
    #   ipv6cidr_block             = null # If null, no IPv6 CIDR block is assigned
    # },
  ]
}

# ── oci-networking.tf ────────────────────────────────────
# Copyright (c) 2022-2024, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

# File Version: 0.10.1

# Dependencies:
#   - defaults.tf file
#   - local.create_new_vcn
#   - local.create_subnets
#   - local.resolved_vcn_compartment_ocid
#   - local.subnets
#   - local.route_tables
#   - local.security_lists
#   - terraform-oci-networking module

################################################################################
#
#       *** Note: Normally, you should not need to edit this file. ***
#
################################################################################
## MODIFICATIONS:
##
##   Date                    Name              Description
##   (DD/MM/YYYY)
##   ----------    ------------------------    --------------------------------------
##   28/05/2024     Kosseila HD (CloudDude)      repatriated networtking modules back to the repo
##                                              from :github.com/oracle-quickstart/terraform-oci-networking//modules/*?ref=0.2.0
##   28/11/2024     Kosseila HD (CloudDude)      updated the content based on last commit 0.9.3 Zero Nine 3 Pull #42
############################################################################################
################################################################################
# Module: Virtual Cloud Network (VCN)
################################################################################
module "vcn" {
  source = "./modules/oci-networking/vcn"
  # Oracle Cloud Infrastructure Tenancy and Compartment OCID
  compartment_ocid = local.vcn_compartment_ocid
  # Deployment Tags + Freeform Tags + Defined Tags
  vcn_tags = local.oci_tag_values
  # Virtual Cloud Network (VCN) arguments
  create_new_vcn          = local.create_new_vcn
  existent_vcn_ocid       = var.existent_vcn_ocid
  cidr_blocks             = local.pre_vcn_cidr_blocks
  display_name            = local.vcn_display_name
  dns_label               = "${local.app_name_for_dns}${local.deploy_id}"
  is_ipv6enabled          = var.is_ipv6enabled
  ipv6private_cidr_blocks = var.ipv6private_cidr_blocks
}

################################################################################
# Module: Subnets
################################################################################
module "subnets" {
  for_each = { for map in local.subnets : map.subnet_name => map }
  source   = "./modules/oci-networking/subnet"
  # Oracle Cloud Infrastructure Tenancy and Compartment OCID
  compartment_ocid = local.vcn_compartment_ocid
  vcn_id           = module.vcn.vcn_id
  # Deployment Tags + Freeform Tags + Defined Tags
  subnet_tags = local.oci_tag_values
  # Subnet arguments
  create_subnet              = local.create_subnets
  subnet_name                = each.value.subnet_name
  cidr_block                 = each.value.cidr_block
  display_name               = try(each.value.display_name, null) # If null, is autogenerated
  dns_label                  = try(each.value.dns_label, null)    # If null, is autogenerated
  prohibit_public_ip_on_vnic = each.value.prohibit_public_ip_on_vnic
  prohibit_internet_ingress  = each.value.prohibit_internet_ingress
  route_table_id = (anytrue([(each.value.alternative_route_table_name == ""), (each.value.alternative_route_table_name == null)])
 ? try(each.value.route_table_id, null)
  : module.route_tables[each.value.alternative_route_table_name].route_table_id)                                                                        # If null, the VCN's default route table is used
  dhcp_options_id   = each.value.dhcp_options_id                                                                                                        # If null, the VCN's default set of DHCP options is used
  security_list_ids = concat(each.value.security_list_ids, [for v in each.value.extra_security_list_names : module.security_lists[v].security_list_id]) # If null, the VCN's default security list is used
  ipv6cidr_block    = each.value.ipv6cidr_block                                                                                                         # If null, no IPv6 CIDR block is assigned
  #   security_list_ids = (anytrue([(each.value.alternative_security_list == ""), (each.value.alternative_security_list == null)]) # If null, the VCN's default security list is used
  #   ? each.value.security_list_ids
  # : [module.security_lists[each.value.alternative_security_list].security_list_id])
}

################################################################################
# Module: Gateways
################################################################################
module "gateways" {
  source = "./modules/oci-networking/gateway"

  # Oracle Cloud Infrastructure Tenancy and Compartment OCID
  compartment_ocid = local.vcn_compartment_ocid
  vcn_id           = module.vcn.vcn_id

  # Deployment Tags + Freeform Tags + Defined Tags
  gateways_tags = local.oci_tag_values

  # Internet Gateway
  create_internet_gateway       = local.create_subnets
  internet_gateway_display_name = "Internet Gateway (${local.deploy_id})"
  internet_gateway_enabled      = true

  # NAT Gateway
  create_nat_gateway       = local.create_subnets
  nat_gateway_display_name = "NAT Gateway (${local.deploy_id})"
  nat_gateway_public_ip_id = null

  # Service Gateway
  create_service_gateway       = local.create_subnets
  service_gateway_display_name = "Service Gateway (${local.deploy_id})"

  # Local Peering Gateway (LPG)
  create_local_peering_gateway       = false
  local_peering_gateway_display_name = "Local Peering Gateway (${local.deploy_id})"
  local_peering_gateway_peer_id      = null
}

################################################################################
# Module: Route Tables
################################################################################
module "route_tables" {
  for_each = { for map in local.route_tables : map.route_table_name => map }
  source   = "./modules/oci-networking/route_table"

  # Oracle Cloud Infrastructure Tenancy and Compartment OCID
  compartment_ocid = local.vcn_compartment_ocid
  vcn_id           = module.vcn.vcn_id

  # Deployment Tags + Freeform Tags + Defined Tags
  route_table_tags = local.oci_tag_values

  # Route Table attributes
  create_route_table = local.create_subnets
  route_table_name   = each.value.route_table_name
  display_name       = try(each.value.display_name, null)
  route_rules        = each.value.route_rules
}

################################################################################
# Module: Security Lists
################################################################################
module "security_lists" {
  for_each = { for map in local.security_lists : map.security_list_name => map }
  source   = "./modules/oci-networking/security_list"

  # Oracle Cloud Infrastructure Tenancy and Compartment OCID
  compartment_ocid = local.vcn_compartment_ocid
  vcn_id           = module.vcn.vcn_id

  # Deployment Tags + Freeform Tags + Defined Tags
  security_list_tags = local.oci_tag_values

  # Security List attributes
  create_security_list   = local.create_subnets
  security_list_name     = each.value.security_list_name
  display_name           = each.value.display_name
  egress_security_rules  = each.value.egress_security_rules
  ingress_security_rules = each.value.ingress_security_rules
}

locals {
  vcn_compartment_ocid = var.create_new_vcn ? local.resolved_vcn_compartment_ocid : var.existent_vcn_compartment_ocid
}

# ── policies.tf ────────────────────────────────────
# Copyright (c) 2023, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#

module "cluster-dynamic-group" {
  source = "./modules/oci-policies"

  providers = {
    oci             = oci
    oci.home_region = oci.home_region
  }

  # Oracle Cloud Infrastructure Tenancy
  tenancy_ocid = var.tenancy_ocid

  # Deployment Tags + Freeform Tags + Defined Tags
  oci_tag_values = local.oci_tag_values

  create_dynamic_group = true
  dynamic_group_name   = "OKE Cluster Nodes"
  dynamic_group_matching_rules = [
    "ALL {instance.compartment.id = '${local.oke_compartment_ocid}'}",
    "ALL {resource.type = 'cluster', resource.compartment.id = '${local.oke_compartment_ocid}'}"
  ]

  count = var.create_dynamic_group_for_nodes_in_compartment ? 1 : 0
}

module "cluster-compartment-policies" {
  source = "./modules/oci-policies"

  providers = {
    oci             = oci
    oci.home_region = oci.home_region
  }

  # Oracle Cloud Infrastructure Tenancy and Compartment OCID
  tenancy_ocid     = var.tenancy_ocid
  compartment_ocid = local.oke_compartment_ocid

  oci_tag_values = local.oci_tag_values

  create_policy = true
  policy_name   = "OKE Cluster Compartment Policies"
  policy_statements = [
    "Allow dynamic-group ${local.dynamic_group_name} to manage cluster-node-pools in compartment id ${local.oke_compartment_ocid}",
    "Allow dynamic-group ${local.dynamic_group_name} to manage instance-family in compartment id ${local.oke_compartment_ocid}",
    "Allow dynamic-group ${local.dynamic_group_name} to use subnets in compartment id ${local.oke_compartment_ocid}",
    "Allow dynamic-group ${local.dynamic_group_name} to read virtual-network-family in compartment id ${local.oke_compartment_ocid}",
    "Allow dynamic-group ${local.dynamic_group_name} to use vnics in compartment id ${local.oke_compartment_ocid}",
    "Allow dynamic-group ${local.dynamic_group_name} to inspect compartments in compartment id ${local.oke_compartment_ocid}",
    "Allow dynamic-group ${local.dynamic_group_name} to use network-security-groups in compartment id ${local.oke_compartment_ocid}",
    "Allow dynamic-group ${local.dynamic_group_name} to use private-ips in compartment id ${local.oke_compartment_ocid}",
    "Allow dynamic-group ${local.dynamic_group_name} to manage public-ips in compartment id ${local.oke_compartment_ocid}"
  ]

  count = var.create_compartment_policies ? 1 : 0
}

locals {
  dynamic_group_name = var.create_dynamic_group_for_nodes_in_compartment ? module.cluster-dynamic-group.0.dynamic_group_name : var.existent_dynamic_group_for_nodes_in_compartment
}