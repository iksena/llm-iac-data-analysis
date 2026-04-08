data "aws_emr_supported_instance_types" "this" {
  region        = var.region
  release_label = var.release_label
}