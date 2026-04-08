resource "aws_docdb_cluster_instance" "docdb" {
  count = var.instance_count

  identifier_prefix = var.cluster_instance_name_prefix == null ? "${var.name_prefix}-${count.index}-" : "${var.cluster_instance_name_prefix}-${count.index}-"

  apply_immediately               = var.apply_immediately
  cluster_identifier              = aws_docdb_cluster.docdb.id
  instance_class                  = var.instance_class
  enable_performance_insights     = var.enable_performance_insights
  performance_insights_kms_key_id = var.performance_insights_kms_key
  promotion_tier                  = var.promotion_tier
  ca_cert_identifier              = var.ca_cert_identifier

  tags = var.tags
}

resource "aws_docdb_cluster" "docdb" {
  cluster_identifier = var.name_prefix

  engine         = var.engine
  engine_version = var.engine_version
  port           = var.port

  master_username = var.master_username
  master_password = var.master_password

  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window

  skip_final_snapshot = var.skip_final_snapshot
  apply_immediately   = var.apply_immediately

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  vpc_security_group_ids          = var.create_security_group ? concat(var.vpc_security_group_ids, [aws_security_group.main[0].id]) : var.vpc_security_group_ids
  db_subnet_group_name            = aws_docdb_subnet_group.docdb.name
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.docdb_parameter_group.id

  kms_key_id        = var.kms_key_id
  storage_encrypted = var.storage_encrypted

  deletion_protection = var.deletion_protection

  tags = var.tags
}

resource "aws_docdb_subnet_group" "docdb" {
  name_prefix = "${var.name_prefix}-subnet-group-"

  subnet_ids = var.subnet_ids

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_docdb_cluster_parameter_group" "docdb_parameter_group" {
  name_prefix = "${var.name_prefix}-parameter-group-"
  description = "docdb cluster parameter group"

  family = "${var.engine}${substr(var.engine_version, 0, 3)}"

  dynamic "parameter" {
    for_each = var.parameters
    content {
      apply_method = parameter.value.apply_method
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }

  tags = var.tags
}
