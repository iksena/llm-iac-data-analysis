resource "aws_ec2_managed_prefix_list_entry" "this" {
  region         = var.region
  cidr           = var.cidr
  description    = var.description
  prefix_list_id = var.prefix_list_id
}