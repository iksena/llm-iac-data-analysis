resource "aws_fsx_ontap_storage_virtual_machine" "this" {
  region                     = var.region
  file_system_id             = var.file_system_id
  name                       = var.name
  root_volume_security_style = var.root_volume_security_style
  svm_admin_password         = var.svm_admin_password
  tags                       = var.tags

  dynamic "active_directory_configuration" {
    for_each = var.active_directory_configuration != null ? [var.active_directory_configuration] : []
    content {
      netbios_name = active_directory_configuration.value.netbios_name

      dynamic "self_managed_active_directory_configuration" {
        for_each = active_directory_configuration.value.self_managed_active_directory_configuration != null ? [active_directory_configuration.value.self_managed_active_directory_configuration] : []
        content {
          dns_ips                                = self_managed_active_directory_configuration.value.dns_ips
          domain_name                            = self_managed_active_directory_configuration.value.domain_name
          password                               = self_managed_active_directory_configuration.value.password
          username                               = self_managed_active_directory_configuration.value.username
          file_system_administrators_group       = self_managed_active_directory_configuration.value.file_system_administrators_group
          organizational_unit_distinguished_name = self_managed_active_directory_configuration.value.organizational_unit_distinguished_name
        }
      }
    }
  }

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
    update = var.timeouts.update
  }
}