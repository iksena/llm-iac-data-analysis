resource "aws_kinesis_stream" "data_stream" {
  name             = var.kinesis_stream_name
  retention_period = 24   # Hours
  stream_mode_details {
    stream_mode = "ON_DEMAND"   # No need to manually manage shards
  }
}