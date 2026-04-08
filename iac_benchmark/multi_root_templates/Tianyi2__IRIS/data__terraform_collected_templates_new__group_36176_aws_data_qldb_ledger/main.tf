data "aws_qldb_ledger" "this" {
  name   = var.name
  region = var.region
}