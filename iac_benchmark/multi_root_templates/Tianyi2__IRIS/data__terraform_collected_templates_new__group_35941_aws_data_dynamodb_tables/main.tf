data "aws_dynamodb_tables" "this" {
  region = var.region
}