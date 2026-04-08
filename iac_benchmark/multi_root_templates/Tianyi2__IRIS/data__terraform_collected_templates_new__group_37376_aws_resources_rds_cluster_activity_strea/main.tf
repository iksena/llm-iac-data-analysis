resource "aws_rds_cluster_activity_stream" "this" {
  region                              = var.region
  resource_arn                        = var.resource_arn
  mode                                = var.mode
  kms_key_id                          = var.kms_key_id
  engine_native_audit_fields_included = var.engine_native_audit_fields_included
}