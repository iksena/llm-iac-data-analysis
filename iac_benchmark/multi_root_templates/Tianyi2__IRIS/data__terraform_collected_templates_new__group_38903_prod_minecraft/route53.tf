resource "aws_route53_record" "minecraft_server" {
  zone_id = data.aws_route53_zone.online.zone_id
  name    = "play.online.ntnu.no"
  type    = "A"
  ttl     = 300
  records = ["129.241.153.251"]
}

resource "aws_route53_record" "minecraft_srv" {
  zone_id = data.aws_route53_zone.online.zone_id
  name    = "_minecraft._tcp.play.online.ntnu.no"
  type    = "SRV"
  ttl     = 300
  records = ["0 5 25565 play.online.ntnu.no"]
}

