resource "aws_cloudfront_realtime_log_config" "this" {
  name          = var.name
  sampling_rate = var.sampling_rate
  fields        = var.fields

  endpoint {
    stream_type = var.endpoint_stream_type

    kinesis_stream_config {
      role_arn   = var.kinesis_stream_config_role_arn
      stream_arn = var.kinesis_stream_config_stream_arn
    }
  }
}