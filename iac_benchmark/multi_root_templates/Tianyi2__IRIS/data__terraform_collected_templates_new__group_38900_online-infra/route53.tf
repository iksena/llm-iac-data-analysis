resource "aws_route53_zone" "online_ntnu_no" {
  name = "online.ntnu.no"
}

resource "aws_route53_zone" "grades_no" {
  name = "grades.no"
}

resource "aws_route53_zone" "vinstraff_no" {
  name = "vinstraff.no"
}
