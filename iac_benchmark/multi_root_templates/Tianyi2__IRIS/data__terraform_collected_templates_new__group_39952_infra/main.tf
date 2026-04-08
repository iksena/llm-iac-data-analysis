locals {
  vpn_dns_name     = "vpn.${var.base_domain}"
  dns_ip           = cidrhost(var.cluster_ip_range, 1)
  vpn_ip           = cidrhost(var.cluster_ip_range, 2)
  k8s_vip          = cidrhost(var.cluster_ip_range, 3)
  k8s_lb_ip        = cidrhost(var.cluster_ip_range, 4)
  control_node_ips = [for i in range(var.talos_vm_config.control.count) : cidrhost(var.cluster_ip_range, 5 + i)]
  worker_node_ips  = [for i in range(var.talos_vm_config.worker.count) : cidrhost(var.cluster_ip_range, 5 + var.talos_vm_config.control.count + i)]
  gpu_node_ip      = cidrhost(var.cluster_ip_range, 5 + var.talos_vm_config.control.count + var.talos_vm_config.worker.count + 1)
  samba_node_ip    = cidrhost(var.cluster_ip_range, 5 + var.talos_vm_config.control.count + var.talos_vm_config.worker.count + 2)
  devbox_node_ip   = cidrhost(var.cluster_ip_range, 5 + var.talos_vm_config.control.count + var.talos_vm_config.worker.count + 3)
  dns_subzone_records = merge(
    { samba = local.samba_node_ip },
    var.dns_subzone_records
  )
}

module "vpn" {
  source                  = "./modules/vpn"
  cluster_name            = var.cluster_name
  cluster_network_gateway = var.cluster_network_gateway
  environment             = var.environment
  proxmox_endpoint        = var.proxmox_endpoint
  proxmox_node_name       = var.proxmox_secondary_node
  ip_address              = local.vpn_ip
  vm_config               = var.vpn_vm_config
  dns_name                = local.vpn_dns_name
  ubuntu_image            = proxmox_virtual_environment_download_file.ubuntu_image.id
}

module "dns" {
  source                  = "./modules/dns"
  cluster_name            = var.cluster_name
  cluster_network_gateway = var.cluster_network_gateway
  environment             = var.environment
  proxmox_endpoint        = var.proxmox_endpoint
  proxmox_node_name       = var.proxmox_secondary_node
  ip_address              = local.dns_ip
  base_domain             = var.base_domain
  subzone_records         = local.dns_subzone_records
  aws_region              = module.route53.aws_region
  aws_route53_zone_id     = module.route53.route_53_zone_id
  aws_iam_credentials     = module.route53.coredns_iam_user
  k8s_lb_ip               = local.k8s_lb_ip
  vm_config               = var.dns_vm_config
  ubuntu_image            = proxmox_virtual_environment_download_file.ubuntu_image.id
}

module "route53" {
  source       = "./modules/route53"
  cluster_name = var.cluster_name
  environment  = var.environment
  base_domain  = var.base_domain
  dns_name     = local.vpn_dns_name
}

module "talos" {
  source                  = "./modules/talos"
  cluster_name            = var.cluster_name
  cluster_network_gateway = var.cluster_network_gateway
  environment             = var.environment
  proxmox_endpoint        = var.proxmox_endpoint
  proxmox_node_name       = var.proxmox_primary_node
  k8s_vip                 = local.k8s_vip
  k8s_lb_ip               = local.k8s_lb_ip
  control_node_ips        = local.control_node_ips
  worker_node_ips         = local.worker_node_ips
  gpu_node_ip             = local.gpu_node_ip
  talos_version           = var.talos_version
  k8s_version             = var.k8s_version
  vm_config               = var.talos_vm_config
  gpu_vm_config           = var.talos_gpu_vm_config
  aws_iam_credentials     = module.route53.talos_iam_user
  aws_region              = module.route53.aws_region
  aws_route53_zone_id     = module.route53.route_53_zone_id
  acme_email              = var.acme_email
  acme_server             = var.acme_server
}

module "samba" {
  source                  = "./modules/samba"
  cluster_name            = var.cluster_name
  cluster_network_gateway = var.cluster_network_gateway
  environment             = var.environment
  proxmox_endpoint        = var.proxmox_endpoint
  proxmox_node_name       = var.proxmox_storage_node
  ip_address              = local.samba_node_ip
  vm_config               = var.samba_vm_config
  ubuntu_image            = proxmox_virtual_environment_download_file.ubuntu_image_storage.id
  guest_user              = var.samba_guest_user
  admin_user              = var.samba_admin_user
  storage_path            = var.samba_storage_path
  samba_directories       = var.samba_directories
  samba_data_disk         = var.samba_data_disk
}

module "devbox" {
  source                  = "./modules/devbox"
  cluster_name            = var.cluster_name
  cluster_network_gateway = var.cluster_network_gateway
  environment             = var.environment
  proxmox_endpoint        = var.proxmox_endpoint
  proxmox_node_name       = var.proxmox_storage_node
  ip_address              = local.devbox_node_ip
  vm_config               = var.devbox_vm_config
  arch_image              = proxmox_virtual_environment_download_file.arch_image.id
  admin_user              = var.devbox_admin_user
  samba_host              = local.samba_node_ip
  samba_mounts = [
    for d in var.samba_directories : {
      name  = d.name
      share = d.name
    }
  ]
  samba_username = module.samba.admin_credentials.username
  samba_password = module.samba.admin_credentials.password
}
