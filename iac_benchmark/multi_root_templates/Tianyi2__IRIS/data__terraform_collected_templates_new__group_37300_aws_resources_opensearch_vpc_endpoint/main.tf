resource "aws_opensearch_vpc_endpoint" "this" {
  region     = var.region
  domain_arn = var.domain_arn

  vpc_options {
    security_group_ids = var.vpc_options_security_group_ids
    subnet_ids         = var.vpc_options_subnet_ids
  }

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
}