data "aws_memorydb_user" "this" {
  region    = var.region
  user_name = var.user_name
}