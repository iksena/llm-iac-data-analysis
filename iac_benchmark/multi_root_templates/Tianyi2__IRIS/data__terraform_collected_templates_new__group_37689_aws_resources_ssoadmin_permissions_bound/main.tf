resource "aws_ssoadmin_permissions_boundary_attachment" "this" {
  region             = var.region
  instance_arn       = var.instance_arn
  permission_set_arn = var.permission_set_arn

  permissions_boundary {
    managed_policy_arn = var.permissions_boundary_managed_policy_arn

    dynamic "customer_managed_policy_reference" {
      for_each = var.permissions_boundary_customer_managed_policy_reference != null ? [var.permissions_boundary_customer_managed_policy_reference] : []
      content {
        name = customer_managed_policy_reference.value.name
        path = customer_managed_policy_reference.value.path
      }
    }
  }

  timeouts {
    create = var.timeouts_create
    delete = var.timeouts_delete
  }
}