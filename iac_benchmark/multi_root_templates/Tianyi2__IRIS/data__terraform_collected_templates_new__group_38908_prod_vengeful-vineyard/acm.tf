module "vengeful_vineyard_bucket_certificate" {
  source = "../../modules/aws-acm-certificate"

  domain  = local.vengeful_domain_name
  zone_id = data.aws_route53_zone.vinstraff_no.zone_id

  providers = {
    aws.regional = aws.us-east-1
  }
}

module "server_certificate" {
  source = "../../modules/aws-acm-certificate"

  domain  = local.vengeful_server_domain_name
  zone_id = data.aws_route53_zone.vinstraff_no.zone_id

  providers = {
    aws.regional = aws
  }
}
