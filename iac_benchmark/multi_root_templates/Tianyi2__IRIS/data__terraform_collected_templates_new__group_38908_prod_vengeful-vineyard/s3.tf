locals {
  vengeful_domain_name        = "vinstraff.no"
  vengeful_server_domain_name = "api.vinstraff.no"
}

module "vengeful_vineyard_bucket" {
  source = "../../modules/aws-s3-public-bucket"

  domain_name     = local.vengeful_domain_name
  certificate_arn = module.vengeful_vineyard_bucket_certificate.certificate_arn
  zone_id         = data.aws_route53_zone.vinstraff_no.zone_id
}
