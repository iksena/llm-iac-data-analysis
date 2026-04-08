data "aws_dms_replication_subnet_group" "this" {
  region                      = var.region
  replication_subnet_group_id = var.replication_subnet_group_id
}