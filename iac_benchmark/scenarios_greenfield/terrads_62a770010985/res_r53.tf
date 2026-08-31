resource "aws_route53_zone" "zone" {
  name    = "${var.env}.app.company-solutions.com"
  comment = "Public zone for app"

  tags = {
    Name = "${var.env}.app.company-solutions.com"
  }
}
