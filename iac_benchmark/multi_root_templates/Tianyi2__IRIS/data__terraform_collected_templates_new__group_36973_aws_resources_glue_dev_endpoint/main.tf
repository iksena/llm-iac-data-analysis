resource "aws_glue_dev_endpoint" "this" {
  region                    = var.region
  arguments                 = var.arguments
  extra_jars_s3_path        = var.extra_jars_s3_path
  extra_python_libs_s3_path = var.extra_python_libs_s3_path
  glue_version              = var.glue_version
  name                      = var.name
  number_of_nodes           = var.number_of_nodes
  number_of_workers         = var.number_of_workers
  public_key                = var.public_key
  public_keys               = var.public_keys
  role_arn                  = var.role_arn
  security_configuration    = var.security_configuration
  security_group_ids        = var.security_group_ids
  subnet_id                 = var.subnet_id
  tags                      = var.tags
  worker_type               = var.worker_type
}