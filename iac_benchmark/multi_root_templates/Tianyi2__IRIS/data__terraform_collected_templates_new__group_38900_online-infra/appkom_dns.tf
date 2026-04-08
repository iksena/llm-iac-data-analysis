resource "aws_route53_record" "appkom_jub_dns" {
  name    = "jub.online.ntnu.no"
  type    = "CNAME"
  zone_id = aws_route53_zone.online_ntnu_no.id
  ttl     = 3600
  records = ["cname.vercel-dns.com"]
}

resource "aws_route53_record" "appkom_jubileum_dns" {
  name    = "jubileum.online.ntnu.no"
  type    = "CNAME"
  zone_id = aws_route53_zone.online_ntnu_no.id
  ttl     = 3600
  records = ["cname.vercel-dns.com"]
}

resource "aws_route53_record" "appkom_autobank_dns" {
  name    = "autobank.online.ntnu.no"
  type    = "CNAME"
  zone_id = aws_route53_zone.online_ntnu_no.id
  ttl     = 3600
  records = ["cb59bebf2653ef11.vercel-dns-016.com."]
}
