resource "aws_opensearchserverless_vpc_endpoint" "this" {
  name               = var.name
  subnet_ids         = var.subnet_ids
  vpc_id             = var.vpc_id
  region             = var.region
  security_group_ids = var.security_group_ids

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
}