data "aws_dms_replication_instance" "this" {
  region                  = var.region
  replication_instance_id = var.replication_instance_id
}