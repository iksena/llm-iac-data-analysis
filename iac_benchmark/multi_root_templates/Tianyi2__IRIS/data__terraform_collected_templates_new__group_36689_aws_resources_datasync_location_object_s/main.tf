resource "aws_datasync_location_object_storage" "this" {
  region             = var.region
  agent_arns         = var.agent_arns
  access_key         = var.access_key
  bucket_name        = var.bucket_name
  secret_key         = var.secret_key
  server_certificate = var.server_certificate
  server_hostname    = var.server_hostname
  server_protocol    = var.server_protocol
  server_port        = var.server_port
  subdirectory       = var.subdirectory
  tags               = var.tags
}