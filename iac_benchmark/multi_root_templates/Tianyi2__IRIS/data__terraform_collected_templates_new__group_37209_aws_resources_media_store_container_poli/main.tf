resource "aws_media_store_container_policy" "this" {
  region         = var.region
  container_name = var.container_name
  policy         = var.policy
}