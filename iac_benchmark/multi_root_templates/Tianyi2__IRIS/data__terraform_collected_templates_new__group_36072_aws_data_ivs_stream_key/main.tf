data "aws_ivs_stream_key" "this" {
  region      = var.region
  channel_arn = var.channel_arn
}