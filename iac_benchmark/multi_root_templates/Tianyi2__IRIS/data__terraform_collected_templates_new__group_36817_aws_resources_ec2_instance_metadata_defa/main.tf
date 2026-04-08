resource "aws_ec2_instance_metadata_defaults" "this" {
  region                      = var.region
  http_endpoint               = var.http_endpoint
  http_tokens                 = var.http_tokens
  http_put_response_hop_limit = var.http_put_response_hop_limit
  instance_metadata_tags      = var.instance_metadata_tags
}