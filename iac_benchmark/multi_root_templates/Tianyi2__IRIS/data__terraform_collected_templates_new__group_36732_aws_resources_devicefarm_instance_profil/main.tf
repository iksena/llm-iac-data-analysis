resource "aws_devicefarm_instance_profile" "this" {
  name                              = var.name
  description                       = var.description
  exclude_app_packages_from_cleanup = var.exclude_app_packages_from_cleanup
  package_cleanup                   = var.package_cleanup
  reboot_after_use                  = var.reboot_after_use
  tags                              = var.tags
}