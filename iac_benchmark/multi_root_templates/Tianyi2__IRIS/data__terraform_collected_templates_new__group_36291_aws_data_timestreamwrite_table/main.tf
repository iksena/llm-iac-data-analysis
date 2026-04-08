data "aws_timestreamwrite_table" "this" {
  region        = var.region
  database_name = var.database_name
  name          = var.name
}