resource "random_uuid" "unique_id" {
}

resource "ibm_resource_instance" "portworx_backup" {

  name              = "${var.portworx_service_name}-${split("-", random_uuid.unique_id.result)[0]}"
  resource_group_id = data.ibm_resource_group.resource_group.id
  service           = var.portworx_service_name
  location          = var.region
  plan              = var.pwx_backup_plan
  tags              = concat([
    "managed_by:portworx_backup_terraform",
    "cluster_name:${var.cluster_name}"
  ], var.tags)

  # Parameters used for deploying the px-bakcup
  parameters = {
    apikey            = var.ibmcloud_api_key,
    namespace         = var.namespace,
    resource_group    = var.resource_group,
    clusters          = var.cluster_name
  }
}

resource "null_resource" "validate_portworx_backup_installation" {
  triggers = {
    namespace      = var.namespace
  }
  provisioner "local-exec" {
    command     = "bash portworx_backup_validation.sh ${self.triggers.namespace}"
    working_dir = "${path.module}/utils"
    interpreter = ["/bin/bash", "-c"]
    on_failure  = fail
  }
  depends_on = [
    ibm_resource_instance.portworx_backup
  ]
}
