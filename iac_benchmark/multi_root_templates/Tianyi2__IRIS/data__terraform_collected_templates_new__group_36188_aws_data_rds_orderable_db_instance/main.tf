data "aws_rds_orderable_db_instance" "this" {
  region                               = var.region
  availability_zone_group              = var.availability_zone_group
  engine_latest_version                = var.engine_latest_version
  engine_version                       = var.engine_version
  engine                               = var.engine
  instance_class                       = var.instance_class
  license_model                        = var.license_model
  preferred_engine_versions            = var.preferred_engine_versions
  preferred_instance_classes           = var.preferred_instance_classes
  read_replica_capable                 = var.read_replica_capable
  storage_type                         = var.storage_type
  supported_engine_modes               = var.supported_engine_modes
  supported_network_types              = var.supported_network_types
  supports_clusters                    = var.supports_clusters
  supports_multi_az                    = var.supports_multi_az
  supports_enhanced_monitoring         = var.supports_enhanced_monitoring
  supports_global_databases            = var.supports_global_databases
  supports_iam_database_authentication = var.supports_iam_database_authentication
  supports_iops                        = var.supports_iops
  supports_kerberos_authentication     = var.supports_kerberos_authentication
  supports_performance_insights        = var.supports_performance_insights
  supports_storage_autoscaling         = var.supports_storage_autoscaling
  supports_storage_encryption          = var.supports_storage_encryption
  vpc                                  = var.vpc
}