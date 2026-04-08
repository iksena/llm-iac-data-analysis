resource "aws_memorydb_multi_region_cluster" "this" {
  multi_region_cluster_name_suffix = var.multi_region_cluster_name_suffix
  node_type                        = var.node_type

  region                            = var.region
  description                       = var.description
  engine                            = var.engine
  engine_version                    = var.engine_version
  multi_region_parameter_group_name = var.multi_region_parameter_group_name
  num_shards                        = var.num_shards
  tags                              = var.tags
  tls_enabled                       = var.tls_enabled

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}