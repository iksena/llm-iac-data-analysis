resource "aws_ssoadmin_customer_managed_policy_attachment" "this" {
  region             = var.region
  instance_arn       = var.instance_arn
  permission_set_arn = var.permission_set_arn

  customer_managed_policy_reference {
    name = var.customer_managed_policy_reference_name
    path = var.customer_managed_policy_reference_path
  }

  timeouts {
    create = var.timeouts_create
    delete = var.timeouts_delete
  }
}