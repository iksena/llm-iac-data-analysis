data "aws_redshiftserverless_workgroup" "this" {
  workgroup_name = var.workgroup_name
  region         = var.region
}