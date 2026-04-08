resource "aws_ec2_instance_connect_endpoint" "this" {
  region             = var.region
  preserve_client_ip = var.preserve_client_ip
  security_group_ids = var.security_group_ids
  subnet_id          = var.subnet_id
  tags               = var.tags

  timeouts {
    create = "10m"
    delete = "10m"
  }
}