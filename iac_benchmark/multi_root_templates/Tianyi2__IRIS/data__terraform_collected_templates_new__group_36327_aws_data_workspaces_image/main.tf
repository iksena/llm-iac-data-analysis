data "aws_workspaces_image" "this" {
  region   = var.region
  image_id = var.image_id
}