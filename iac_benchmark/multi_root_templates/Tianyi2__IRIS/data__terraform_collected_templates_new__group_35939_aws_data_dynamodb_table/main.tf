data "aws_dynamodb_table" "this" {
  name   = var.name
  region = var.region
}