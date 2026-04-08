resource "aws_cloudfront_vpc_origin" "this" {
  vpc_origin_endpoint_config {
    arn                    = var.vpc_origin_endpoint_config.arn
    http_port              = var.vpc_origin_endpoint_config.http_port
    https_port             = var.vpc_origin_endpoint_config.https_port
    name                   = var.vpc_origin_endpoint_config.name
    origin_protocol_policy = var.vpc_origin_endpoint_config.origin_protocol_policy

    origin_ssl_protocols {
      items    = var.vpc_origin_endpoint_config.origin_ssl_protocols.items
      quantity = var.vpc_origin_endpoint_config.origin_ssl_protocols.quantity
    }
  }

  tags = var.tags
}