data "aws_msk_vpc_connection" "this" {
  arn    = var.arn
  region = var.region
}