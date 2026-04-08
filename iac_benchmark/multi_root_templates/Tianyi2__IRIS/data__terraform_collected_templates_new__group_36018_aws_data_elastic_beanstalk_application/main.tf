data "aws_elastic_beanstalk_application" "this" {
  name   = var.name
  region = var.region
}