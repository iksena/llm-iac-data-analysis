resource "aws_iam_virtual_mfa_device" "this" {
  virtual_mfa_device_name = var.virtual_mfa_device_name
  path                    = var.path
  tags                    = var.tags
}