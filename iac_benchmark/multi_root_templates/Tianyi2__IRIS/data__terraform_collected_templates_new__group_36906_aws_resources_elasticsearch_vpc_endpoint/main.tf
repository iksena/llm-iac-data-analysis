resource "aws_elasticsearch_vpc_endpoint" "this" {
  region     = var.region
  domain_arn = var.domain_arn

  vpc_options {
    security_group_ids = var.vpc_options.security_group_ids
    subnet_ids         = var.vpc_options.subnet_ids
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}