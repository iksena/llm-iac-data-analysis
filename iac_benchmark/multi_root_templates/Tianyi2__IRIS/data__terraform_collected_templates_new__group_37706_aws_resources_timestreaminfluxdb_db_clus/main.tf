resource "aws_timestreaminfluxdb_db_cluster" "this" {
  allocated_storage      = var.allocated_storage
  bucket                 = var.bucket
  db_instance_type       = var.db_instance_type
  name                   = var.name
  password               = var.password
  organization           = var.organization
  username               = var.username
  vpc_security_group_ids = var.vpc_security_group_ids
  vpc_subnet_ids         = var.vpc_subnet_ids

  region                        = var.region
  db_parameter_group_identifier = var.db_parameter_group_identifier
  db_storage_type               = var.db_storage_type
  deployment_type               = var.deployment_type
  failover_mode                 = var.failover_mode
  network_type                  = var.network_type
  port                          = var.port
  publicly_accessible           = var.publicly_accessible
  tags                          = var.tags

  dynamic "log_delivery_configuration" {
    for_each = var.log_delivery_configuration != null ? [var.log_delivery_configuration] : []
    content {
      s3_configuration {
        bucket_name = log_delivery_configuration.value.s3_configuration.bucket_name
        enabled     = log_delivery_configuration.value.s3_configuration.enabled
      }
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}