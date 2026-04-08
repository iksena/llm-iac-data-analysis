data "aws_timestreamwrite_database" "this" {
  name = var.database_name
}