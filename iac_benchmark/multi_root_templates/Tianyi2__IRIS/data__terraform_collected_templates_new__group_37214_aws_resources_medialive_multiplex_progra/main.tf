resource "aws_medialive_multiplex_program" "this" {
  multiplex_id = var.multiplex_id
  program_name = var.program_name
  region       = var.region

  multiplex_program_settings {
    program_number             = var.multiplex_program_settings.program_number
    preferred_channel_pipeline = var.multiplex_program_settings.preferred_channel_pipeline

    dynamic "service_descriptor" {
      for_each = var.multiplex_program_settings.service_descriptor != null ? [var.multiplex_program_settings.service_descriptor] : []
      content {
        provider_name = service_descriptor.value.provider_name
        service_name  = service_descriptor.value.service_name
      }
    }

    dynamic "video_settings" {
      for_each = var.multiplex_program_settings.video_settings != null ? [var.multiplex_program_settings.video_settings] : []
      content {
        constant_bitrate = video_settings.value.constant_bitrate

        dynamic "statmux_settings" {
          for_each = video_settings.value.statmux_settings != null ? [video_settings.value.statmux_settings] : []
          content {
            minimum_bitrate = statmux_settings.value.minimum_bitrate
            maximum_bitrate = statmux_settings.value.maximum_bitrate
            priority        = statmux_settings.value.priority
          }
        }
      }
    }
  }
}