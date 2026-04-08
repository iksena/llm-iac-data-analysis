resource "aws_directory_service_shared_directory" "this" {
  directory_id = var.directory_id
  notes        = var.notes
  region       = var.region
  method       = var.method

  target {
    id   = var.target.id
    type = var.target.type
  }

  timeouts {
    delete = var.timeouts.delete
  }
}