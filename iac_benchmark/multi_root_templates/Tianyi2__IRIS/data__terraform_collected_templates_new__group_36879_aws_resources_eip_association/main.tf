resource "aws_eip_association" "this" {
  region               = var.region
  allocation_id        = var.allocation_id
  allow_reassociation  = var.allow_reassociation
  instance_id          = var.instance_id
  network_interface_id = var.network_interface_id
  private_ip_address   = var.private_ip_address
  public_ip            = var.public_ip

  lifecycle {
    precondition {
      condition     = var.instance_id == null || var.network_interface_id == null
      error_message = "You can specify either the instance ID or the network interface ID, but not both."
    }
  }
}