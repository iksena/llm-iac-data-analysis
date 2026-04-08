data "aws_dms_replication_task" "this" {
  region              = var.region
  replication_task_id = var.replication_task_id
}