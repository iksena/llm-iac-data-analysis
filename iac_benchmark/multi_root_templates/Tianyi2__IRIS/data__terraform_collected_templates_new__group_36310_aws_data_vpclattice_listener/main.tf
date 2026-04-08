data "aws_vpclattice_listener" "this" {
  service_identifier  = var.service_identifier
  listener_identifier = var.listener_identifier
  region              = var.region
}