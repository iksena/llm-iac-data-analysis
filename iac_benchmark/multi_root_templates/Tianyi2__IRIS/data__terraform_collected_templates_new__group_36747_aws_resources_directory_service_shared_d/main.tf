resource "aws_directory_service_shared_directory_accepter" "this" {
  region              = var.region
  shared_directory_id = var.shared_directory_id

  timeouts {
    create = "60m"
    delete = "60m"
  }
}