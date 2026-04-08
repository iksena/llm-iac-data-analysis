resource "aws_ec2_tag" "this" {
  region      = var.region
  resource_id = var.resource_id
  key         = var.key
  value       = var.value
}