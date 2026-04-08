resource "aws_medialive_multiplex" "this" {
  availability_zones = var.availability_zones
  name               = var.name
  region             = var.region
  start_multiplex    = var.start_multiplex
  tags               = var.tags

  multiplex_settings {
    transport_stream_bitrate                = var.multiplex_settings.transport_stream_bitrate
    transport_stream_id                     = var.multiplex_settings.transport_stream_id
    transport_stream_reserved_bitrate       = var.multiplex_settings.transport_stream_reserved_bitrate
    maximum_video_buffer_delay_milliseconds = var.multiplex_settings.maximum_video_buffer_delay_milliseconds
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}