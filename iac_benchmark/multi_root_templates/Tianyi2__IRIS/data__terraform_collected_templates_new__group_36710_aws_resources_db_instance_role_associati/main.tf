resource "aws_db_instance_role_association" "this" {
  region                 = var.region
  db_instance_identifier = var.db_instance_identifier
  feature_name           = var.feature_name
  role_arn               = var.role_arn

  timeouts {
    create = "10m"
    delete = "10m"
  }
}