resource "aws_cloudhsm_v2_hsm" "this" {
  region            = var.region
  cluster_id        = var.cluster_id
  subnet_id         = var.subnet_id
  availability_zone = var.availability_zone
  ip_address        = var.ip_address

  lifecycle {
    precondition {
      condition     = (var.subnet_id != null) != (var.availability_zone != null)
      error_message = "Either subnet_id or availability_zone must be specified, but not both."
    }
  }
}