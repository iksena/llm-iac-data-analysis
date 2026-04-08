# Create random password
resource "random_password" "vm_password" {
  count = var.resource_instance_count

  length  = 20
  special = true
}
