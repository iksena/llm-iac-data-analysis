data "aws_connect_security_profile" "this" {
  instance_id         = var.instance_id
  security_profile_id = var.security_profile_id
  name                = var.name
  region              = var.region
}