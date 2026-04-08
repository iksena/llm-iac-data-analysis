data "aws_ec2_instance_type" "this" {
  region        = var.region
  instance_type = var.instance_type
}