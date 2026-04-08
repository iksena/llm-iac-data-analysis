resource "aws_dms_replication_instance" "this" {
  region                       = var.region
  allocated_storage            = var.allocated_storage
  allow_major_version_upgrade  = var.allow_major_version_upgrade
  apply_immediately            = var.apply_immediately
  auto_minor_version_upgrade   = var.auto_minor_version_upgrade
  availability_zone            = var.availability_zone
  dns_name_servers             = var.dns_name_servers != null ? join(",", var.dns_name_servers) : null
  engine_version               = var.engine_version
  kms_key_arn                  = var.kms_key_arn
  multi_az                     = var.multi_az
  network_type                 = var.network_type
  preferred_maintenance_window = var.preferred_maintenance_window
  publicly_accessible          = var.publicly_accessible
  replication_instance_class   = var.replication_instance_class
  replication_instance_id      = var.replication_instance_id
  replication_subnet_group_id  = var.replication_subnet_group_id
  tags                         = var.tags
  vpc_security_group_ids       = var.vpc_security_group_ids

  dynamic "kerberos_authentication_settings" {
    for_each = var.kerberos_authentication_settings != null ? [var.kerberos_authentication_settings] : []
    content {
      key_cache_secret_iam_arn = kerberos_authentication_settings.value.key_cache_secret_iam_arn
      key_cache_secret_id      = kerberos_authentication_settings.value.key_cache_secret_id
      krb5_file_contents       = kerberos_authentication_settings.value.krb5_file_contents
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}