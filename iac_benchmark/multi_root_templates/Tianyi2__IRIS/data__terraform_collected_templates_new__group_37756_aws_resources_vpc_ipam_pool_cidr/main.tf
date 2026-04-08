resource "aws_vpc_ipam_pool_cidr" "this" {
  region         = var.region
  cidr           = var.cidr
  ipam_pool_id   = var.ipam_pool_id
  netmask_length = var.netmask_length

  dynamic "cidr_authorization_context" {
    for_each = var.cidr_authorization_context != null ? [var.cidr_authorization_context] : []
    content {
      message   = cidr_authorization_context.value.message
      signature = cidr_authorization_context.value.signature
    }
  }
}