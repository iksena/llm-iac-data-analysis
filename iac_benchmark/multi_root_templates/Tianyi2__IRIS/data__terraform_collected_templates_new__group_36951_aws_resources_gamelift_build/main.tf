resource "aws_gamelift_build" "this" {
  region           = var.region
  name             = var.name
  operating_system = var.operating_system
  version          = var.build_version
  tags             = var.tags

  storage_location {
    bucket         = var.storage_location.bucket
    key            = var.storage_location.key
    role_arn       = var.storage_location.role_arn
    object_version = var.storage_location.object_version
  }
}