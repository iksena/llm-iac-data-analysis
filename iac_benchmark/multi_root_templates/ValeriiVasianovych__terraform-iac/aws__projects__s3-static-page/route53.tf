resource "aws_route53_record" "root" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.bucket_name
  type    = "A"
  alias {
    name                   = "s3-website-${var.region}.amazonaws.com."
    zone_id                = var.zone_id
    evaluate_target_health = false
  }
  depends_on = [aws_s3_bucket.static_website]
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "www.${var.bucket_name}"
  type    = "A"
  alias {
    name                   = "s3-website-${var.region}.amazonaws.com."
    zone_id                = var.zone_id
    evaluate_target_health = false
  }
  depends_on = [aws_s3_bucket.redirect_bucket]
}
