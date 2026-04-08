resource "aws_dms_s3_endpoint" "this" {
  # Required arguments
  bucket_name             = var.bucket_name
  endpoint_id             = var.endpoint_id
  endpoint_type           = var.endpoint_type
  service_access_role_arn = var.service_access_role_arn

  # Optional arguments
  region                                      = var.region
  add_column_name                             = var.add_column_name
  add_trailing_padding_character              = var.add_trailing_padding_character
  bucket_folder                               = var.bucket_folder
  canned_acl_for_objects                      = var.canned_acl_for_objects
  cdc_inserts_and_updates                     = var.cdc_inserts_and_updates
  cdc_inserts_only                            = var.cdc_inserts_only
  cdc_max_batch_interval                      = var.cdc_max_batch_interval
  cdc_min_file_size                           = var.cdc_min_file_size
  cdc_path                                    = var.cdc_path
  certificate_arn                             = var.certificate_arn
  compression_type                            = var.compression_type
  csv_delimiter                               = var.csv_delimiter
  csv_no_sup_value                            = var.csv_no_sup_value
  csv_null_value                              = var.csv_null_value
  csv_row_delimiter                           = var.csv_row_delimiter
  data_format                                 = var.data_format
  data_page_size                              = var.data_page_size
  date_partition_delimiter                    = var.date_partition_delimiter
  date_partition_enabled                      = var.date_partition_enabled
  date_partition_sequence                     = var.date_partition_sequence
  date_partition_timezone                     = var.date_partition_timezone
  detach_target_on_lob_lookup_failure_parquet = var.detach_target_on_lob_lookup_failure_parquet
  dict_page_size_limit                        = var.dict_page_size_limit
  enable_statistics                           = var.enable_statistics
  encoding_type                               = var.encoding_type
  encryption_mode                             = var.encryption_mode
  expected_bucket_owner                       = var.expected_bucket_owner
  external_table_definition                   = var.external_table_definition
  glue_catalog_generation                     = var.glue_catalog_generation
  ignore_header_rows                          = var.ignore_header_rows
  include_op_for_full_load                    = var.include_op_for_full_load
  kms_key_arn                                 = var.kms_key_arn
  max_file_size                               = var.max_file_size
  parquet_timestamp_in_millisecond            = var.parquet_timestamp_in_millisecond
  parquet_version                             = var.parquet_version
  preserve_transactions                       = var.preserve_transactions
  rfc_4180                                    = var.rfc_4180
  row_group_length                            = var.row_group_length
  server_side_encryption_kms_key_id           = var.server_side_encryption_kms_key_id
  ssl_mode                                    = var.ssl_mode
  tags                                        = var.tags
  timestamp_column_name                       = var.timestamp_column_name
  use_csv_no_sup_value                        = var.use_csv_no_sup_value
  use_task_start_time_for_full_load_timestamp = var.use_task_start_time_for_full_load_timestamp

  timeouts {
    create = var.timeout_create
    delete = var.timeout_delete
  }
}