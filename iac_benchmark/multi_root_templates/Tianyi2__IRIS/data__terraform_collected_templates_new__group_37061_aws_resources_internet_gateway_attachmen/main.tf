resource "aws_internet_gateway_attachment" "this" {
  region              = var.region
  internet_gateway_id = var.internet_gateway_id
  vpc_id              = var.vpc_id

  timeouts {
    create = "20m"
    delete = "20m"
  }
}