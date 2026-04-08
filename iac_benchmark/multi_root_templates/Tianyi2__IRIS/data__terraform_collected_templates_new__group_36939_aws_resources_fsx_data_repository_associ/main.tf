resource "aws_fsx_data_repository_association" "this" {
  region                           = var.region
  batch_import_meta_data_on_create = var.batch_import_meta_data_on_create
  data_repository_path             = var.data_repository_path
  file_system_id                   = var.file_system_id
  file_system_path                 = var.file_system_path
  imported_file_chunk_size         = var.imported_file_chunk_size
  delete_data_in_filesystem        = var.delete_data_in_filesystem
  tags                             = var.tags

  dynamic "s3" {
    for_each = var.s3 != null ? [var.s3] : []
    content {
      dynamic "auto_export_policy" {
        for_each = s3.value.auto_export_policy != null ? [s3.value.auto_export_policy] : []
        content {
          events = auto_export_policy.value.events
        }
      }

      dynamic "auto_import_policy" {
        for_each = s3.value.auto_import_policy != null ? [s3.value.auto_import_policy] : []
        content {
          events = auto_import_policy.value.events
        }
      }
    }
  }
}