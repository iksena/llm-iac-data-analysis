resource "aws_glue_partition_index" "this" {
  region        = var.region
  table_name    = var.table_name
  database_name = var.database_name
  catalog_id    = var.catalog_id

  partition_index {
    index_name = var.partition_index.index_name
    keys       = var.partition_index.keys
  }

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}