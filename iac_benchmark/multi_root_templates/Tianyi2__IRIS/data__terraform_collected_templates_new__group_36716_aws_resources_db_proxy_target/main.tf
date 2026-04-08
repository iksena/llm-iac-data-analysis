resource "aws_db_proxy_target" "this" {
  region                 = var.region
  db_proxy_name          = var.db_proxy_name
  target_group_name      = var.target_group_name
  db_instance_identifier = var.db_instance_identifier
  db_cluster_identifier  = var.db_cluster_identifier
}