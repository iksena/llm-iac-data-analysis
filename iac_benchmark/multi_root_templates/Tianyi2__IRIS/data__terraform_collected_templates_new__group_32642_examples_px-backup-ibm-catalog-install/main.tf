module "portworx_backup" {
  # IBM Provider configurations
  source = "../.."
  ibmcloud_api_key = var.ibmcloud_api_key

  # IKS cluster configuration
  cluster_name = var.cluster_name
  resource_group = var.resource_group

  # Portworx backup configuration
  portworx_service_name = var.portworx_service_name

}