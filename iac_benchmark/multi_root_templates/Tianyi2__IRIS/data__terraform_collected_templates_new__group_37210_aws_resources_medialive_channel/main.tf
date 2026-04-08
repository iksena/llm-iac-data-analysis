resource "aws_medialive_channel" "this" {
  name          = var.name
  channel_class = var.channel_class
  role_arn      = var.role_arn
  region        = var.region
  log_level     = var.log_level
  start_channel = var.start_channel
  tags          = var.tags

  dynamic "input_specification" {
    for_each = var.input_specification != null ? [var.input_specification] : []
    content {
      codec            = input_specification.value.codec
      input_resolution = input_specification.value.input_resolution
      maximum_bitrate  = input_specification.value.maximum_bitrate
    }
  }

  dynamic "cdi_input_specification" {
    for_each = var.cdi_input_specification != null ? [var.cdi_input_specification] : []
    content {
      resolution = cdi_input_specification.value.resolution
    }
  }

  dynamic "input_attachments" {
    for_each = var.input_attachments != null ? var.input_attachments : []
    content {
      input_attachment_name = input_attachments.value.input_attachment_name
      input_id              = input_attachments.value.input_id

      dynamic "input_settings" {
        for_each = input_attachments.value.input_settings != null ? [input_attachments.value.input_settings] : []
        content {
          deblock_filter            = input_settings.value.deblock_filter
          denoise_filter            = input_settings.value.denoise_filter
          filter_strength           = input_settings.value.filter_strength
          input_filter              = input_settings.value.input_filter
          scte35_pid                = input_settings.value.scte35_pid
          smpte2038_data_preference = input_settings.value.smpte2038_data_preference
          source_end_behavior       = input_settings.value.source_end_behavior

          dynamic "audio_selector" {
            for_each = input_settings.value.audio_selector != null ? input_settings.value.audio_selector : []
            content {
              name = audio_selector.value.name

              dynamic "selector_settings" {
                for_each = audio_selector.value.selector_settings != null ? [audio_selector.value.selector_settings] : []
                content {
                  dynamic "audio_hls_rendition_selection" {
                    for_each = selector_settings.value.audio_hls_rendition_selection != null ? [selector_settings.value.audio_hls_rendition_selection] : []
                    content {
                      group_id = audio_hls_rendition_selection.value.group_id
                      name     = audio_hls_rendition_selection.value.name
                    }
                  }

                  dynamic "audio_language_selection" {
                    for_each = selector_settings.value.audio_language_selection != null ? [selector_settings.value.audio_language_selection] : []
                    content {
                      language_code             = audio_language_selection.value.language_code
                      language_selection_policy = audio_language_selection.value.language_selection_policy
                    }
                  }

                  dynamic "audio_pid_selection" {
                    for_each = selector_settings.value.audio_pid_selection != null ? [selector_settings.value.audio_pid_selection] : []
                    content {
                      pid = audio_pid_selection.value.pid
                    }
                  }

                  dynamic "audio_track_selection" {
                    for_each = selector_settings.value.audio_track_selection != null ? [selector_settings.value.audio_track_selection] : []
                    content {
                      dynamic "tracks" {
                        for_each = audio_track_selection.value.tracks != null ? audio_track_selection.value.tracks : []
                        content {
                          track = tracks.value.track
                        }
                      }

                      dynamic "dolby_e_decode" {
                        for_each = audio_track_selection.value.dolby_e_decode != null ? [audio_track_selection.value.dolby_e_decode] : []
                        content {
                          program_selection = dolby_e_decode.value.program_selection
                        }
                      }
                    }
                  }
                }
              }
            }
          }

          dynamic "caption_selector" {
            for_each = input_settings.value.caption_selector != null ? input_settings.value.caption_selector : []
            content {
              name          = caption_selector.value.name
              language_code = caption_selector.value.language_code

              dynamic "selector_settings" {
                for_each = caption_selector.value.selector_settings != null ? [caption_selector.value.selector_settings] : []
                content {
                  dynamic "ancillary_source_settings" {
                    for_each = selector_settings.value.ancillary_source_settings != null ? [selector_settings.value.ancillary_source_settings] : []
                    content {
                      source_ancillary_channel_number = ancillary_source_settings.value.source_ancillary_channel_number
                    }
                  }

                  dynamic "dvb_sub_source_settings" {
                    for_each = selector_settings.value.dvb_sub_source_settings != null ? [selector_settings.value.dvb_sub_source_settings] : []
                    content {
                      ocr_language = dvb_sub_source_settings.value.ocr_language
                      pid          = dvb_sub_source_settings.value.pid
                    }
                  }

                  dynamic "embedded_source_settings" {
                    for_each = selector_settings.value.embedded_source_settings != null ? [selector_settings.value.embedded_source_settings] : []
                    content {
                      convert_608_to_708        = embedded_source_settings.value.convert_608_to_708
                      scte20_detection          = embedded_source_settings.value.scte20_detection
                      source_608_channel_number = embedded_source_settings.value.source_608_channel_number
                    }
                  }

                  dynamic "scte20_source_settings" {
                    for_each = selector_settings.value.scte20_source_settings != null ? [selector_settings.value.scte20_source_settings] : []
                    content {
                      convert_608_to_708        = scte20_source_settings.value.convert_608_to_708
                      source_608_channel_number = scte20_source_settings.value.source_608_channel_number
                    }
                  }

                  dynamic "scte27_source_settings" {
                    for_each = selector_settings.value.scte27_source_settings != null ? [selector_settings.value.scte27_source_settings] : []
                    content {
                      ocr_language = scte27_source_settings.value.ocr_language
                      pid          = scte27_source_settings.value.pid
                    }
                  }

                  dynamic "teletext_source_settings" {
                    for_each = selector_settings.value.teletext_source_settings != null ? [selector_settings.value.teletext_source_settings] : []
                    content {
                      page_number = teletext_source_settings.value.page_number

                      dynamic "output_rectangle" {
                        for_each = teletext_source_settings.value.output_rectangle != null ? [teletext_source_settings.value.output_rectangle] : []
                        content {
                          height      = output_rectangle.value.height
                          left_offset = output_rectangle.value.left_offset
                          top_offset  = output_rectangle.value.top_offset
                          width       = output_rectangle.value.width
                        }
                      }
                    }
                  }
                }
              }
            }
          }

          dynamic "network_input_settings" {
            for_each = input_settings.value.network_input_settings != null ? [input_settings.value.network_input_settings] : []
            content {
              server_validation = network_input_settings.value.server_validation

              dynamic "hls_input_settings" {
                for_each = network_input_settings.value.hls_input_settings != null ? [network_input_settings.value.hls_input_settings] : []
                content {
                  bandwidth       = hls_input_settings.value.bandwidth
                  buffer_segments = hls_input_settings.value.buffer_segments
                  retries         = hls_input_settings.value.retries
                  retry_interval  = hls_input_settings.value.retry_interval
                }
              }
            }
          }
        }
      }

      dynamic "automatic_input_failover_settings" {
        for_each = input_attachments.value.automatic_input_failover_settings != null ? [input_attachments.value.automatic_input_failover_settings] : []
        content {
          secondary_input_id    = automatic_input_failover_settings.value.secondary_input_id
          error_clear_time_msec = automatic_input_failover_settings.value.error_clear_time_msec
          input_preference      = automatic_input_failover_settings.value.input_preference

          dynamic "failover_condition" {
            for_each = automatic_input_failover_settings.value.failover_condition != null ? automatic_input_failover_settings.value.failover_condition : []
            content {
              dynamic "failover_condition_settings" {
                for_each = failover_condition.value.failover_condition_settings != null ? [failover_condition.value.failover_condition_settings] : []
                content {
                  dynamic "audio_silence_settings" {
                    for_each = failover_condition_settings.value.audio_silence_settings != null ? [failover_condition_settings.value.audio_silence_settings] : []
                    content {
                      audio_selector_name          = audio_silence_settings.value.audio_selector_name
                      audio_silence_threshold_msec = audio_silence_settings.value.audio_silence_threshold_msec
                    }
                  }

                  dynamic "input_loss_settings" {
                    for_each = failover_condition_settings.value.input_loss_settings != null ? [failover_condition_settings.value.input_loss_settings] : []
                    content {
                      input_loss_threshold_msec = input_loss_settings.value.input_loss_threshold_msec
                    }
                  }

                  dynamic "video_black_settings" {
                    for_each = failover_condition_settings.value.video_black_settings != null ? [failover_condition_settings.value.video_black_settings] : []
                    content {
                      black_detect_threshold     = video_black_settings.value.black_detect_threshold
                      video_black_threshold_msec = video_black_settings.value.video_black_threshold_msec
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  dynamic "maintenance" {
    for_each = var.maintenance != null ? [var.maintenance] : []
    content {
      maintenance_day        = maintenance.value.maintenance_day
      maintenance_start_time = maintenance.value.maintenance_start_time
    }
  }

  dynamic "destinations" {
    for_each = var.destinations
    content {
      id = destinations.value.id

      dynamic "media_package_settings" {
        for_each = destinations.value.media_package_settings != null ? [destinations.value.media_package_settings] : []
        content {
          channel_id = media_package_settings.value.channel_id
        }
      }

      dynamic "multiplex_settings" {
        for_each = destinations.value.multiplex_settings != null ? [destinations.value.multiplex_settings] : []
        content {
          multiplex_id = multiplex_settings.value.multiplex_id
          program_name = multiplex_settings.value.program_name
        }
      }

      dynamic "settings" {
        for_each = destinations.value.settings != null ? destinations.value.settings : []
        content {
          password_param = settings.value.password_param
          stream_name    = settings.value.stream_name
          url            = settings.value.url
          username       = settings.value.username
        }
      }
    }
  }

  dynamic "encoder_settings" {
    for_each = var.encoder_settings != null ? [var.encoder_settings] : []
    content {
      dynamic "timecode_config" {
        for_each = encoder_settings.value.timecode_config != null ? [encoder_settings.value.timecode_config] : []
        content {
          source         = timecode_config.value.source
          sync_threshold = timecode_config.value.sync_threshold
        }
      }

      dynamic "audio_descriptions" {
        for_each = encoder_settings.value.audio_descriptions != null ? encoder_settings.value.audio_descriptions : []
        content {
          audio_selector_name = audio_descriptions.value.audio_selector_name
          name                = audio_descriptions.value.name
          audio_type          = audio_descriptions.value.audio_type
          audio_type_control  = audio_descriptions.value.audio_type_control

          dynamic "audio_normalization_settings" {
            for_each = audio_descriptions.value.audio_normalization_settings != null ? [audio_descriptions.value.audio_normalization_settings] : []
            content {
              algorithm         = audio_normalization_settings.value.algorithm
              algorithm_control = audio_normalization_settings.value.algorithm_control
              target_lkfs       = audio_normalization_settings.value.target_lkfs
            }
          }

          dynamic "audio_watermark_settings" {
            for_each = audio_descriptions.value.audio_watermark_settings != null ? [audio_descriptions.value.audio_watermark_settings] : []
            content {
            }
          }

          dynamic "codec_settings" {
            for_each = audio_descriptions.value.codec_settings != null ? [audio_descriptions.value.codec_settings] : []
            content {
              dynamic "aac_settings" {
                for_each = codec_settings.value.aac_settings != null ? [codec_settings.value.aac_settings] : []
                content {
                  bitrate           = aac_settings.value.bitrate
                  coding_mode       = aac_settings.value.coding_mode
                  input_type        = aac_settings.value.input_type
                  profile           = aac_settings.value.profile
                  rate_control_mode = aac_settings.value.rate_control_mode
                  raw_format        = aac_settings.value.raw_format
                  sample_rate       = aac_settings.value.sample_rate
                  spec              = aac_settings.value.spec
                  vbr_quality       = aac_settings.value.vbr_quality
                }
              }

              dynamic "ac3_settings" {
                for_each = codec_settings.value.ac3_settings != null ? [codec_settings.value.ac3_settings] : []
                content {
                  bitrate          = ac3_settings.value.bitrate
                  bitstream_mode   = ac3_settings.value.bitstream_mode
                  coding_mode      = ac3_settings.value.coding_mode
                  dialnorm         = ac3_settings.value.dialnorm
                  drc_profile      = ac3_settings.value.drc_profile
                  lfe_filter       = ac3_settings.value.lfe_filter
                  metadata_control = ac3_settings.value.metadata_control
                }
              }

              dynamic "eac3_atmos_settings" {
                for_each = codec_settings.value.eac3_atmos_settings != null ? [codec_settings.value.eac3_atmos_settings] : []
                content {
                  bitrate       = eac3_atmos_settings.value.bitrate
                  coding_mode   = eac3_atmos_settings.value.coding_mode
                  dialnorm      = eac3_atmos_settings.value.dialnorm
                  drc_line      = eac3_atmos_settings.value.drc_line
                  drc_rf        = eac3_atmos_settings.value.drc_rf
                  height_trim   = eac3_atmos_settings.value.height_trim
                  surround_trim = eac3_atmos_settings.value.surround_trim
                }
              }

              dynamic "eac3_settings" {
                for_each = codec_settings.value.eac3_settings != null ? [codec_settings.value.eac3_settings] : []
                content {
                  attenuation_control = eac3_settings.value.attenuation_control
                  bitrate             = eac3_settings.value.bitrate
                  bitstream_mode      = eac3_settings.value.bitstream_mode
                  coding_mode         = eac3_settings.value.coding_mode
                }
              }
            }
          }
        }
      }

      dynamic "video_descriptions" {
        for_each = encoder_settings.value.video_descriptions != null ? encoder_settings.value.video_descriptions : []
        content {
          name             = video_descriptions.value.name
          height           = video_descriptions.value.height
          respond_to_afd   = video_descriptions.value.respond_to_afd
          scaling_behavior = video_descriptions.value.scaling_behavior
          sharpness        = video_descriptions.value.sharpness
          width            = video_descriptions.value.width

          dynamic "codec_settings" {
            for_each = video_descriptions.value.codec_settings != null ? [video_descriptions.value.codec_settings] : []
            content {
              dynamic "frame_capture_settings" {
                for_each = codec_settings.value.frame_capture_settings != null ? [codec_settings.value.frame_capture_settings] : []
                content {
                  capture_interval       = frame_capture_settings.value.capture_interval
                  capture_interval_units = frame_capture_settings.value.capture_interval_units
                }
              }

              dynamic "h264_settings" {
                for_each = codec_settings.value.h264_settings != null ? [codec_settings.value.h264_settings] : []
                content {
                  adaptive_quantization   = h264_settings.value.adaptive_quantization
                  afd_signaling           = h264_settings.value.afd_signaling
                  bitrate                 = h264_settings.value.bitrate
                  buf_fill_pct            = h264_settings.value.buf_fill_pct
                  buf_size                = h264_settings.value.buf_size
                  color_metadata          = h264_settings.value.color_metadata
                  entropy_encoding        = h264_settings.value.entropy_encoding
                  fixed_afd               = h264_settings.value.fixed_afd
                  flicker_aq              = h264_settings.value.flicker_aq
                  force_field_pictures    = h264_settings.value.force_field_pictures
                  framerate_control       = h264_settings.value.framerate_control
                  framerate_denominator   = h264_settings.value.framerate_denominator
                  framerate_numerator     = h264_settings.value.framerate_numerator
                  gop_b_reference         = h264_settings.value.gop_b_reference
                  gop_closed_cadence      = h264_settings.value.gop_closed_cadence
                  gop_num_b_frames        = h264_settings.value.gop_num_b_frames
                  gop_size                = h264_settings.value.gop_size
                  gop_size_units          = h264_settings.value.gop_size_units
                  level                   = h264_settings.value.level
                  look_ahead_rate_control = h264_settings.value.look_ahead_rate_control
                  max_bitrate             = h264_settings.value.max_bitrate
                  min_i_interval          = h264_settings.value.min_i_interval
                  num_ref_frames          = h264_settings.value.num_ref_frames
                  par_control             = h264_settings.value.par_control
                  par_denominator         = h264_settings.value.par_denominator
                  par_numerator           = h264_settings.value.par_numerator
                  profile                 = h264_settings.value.profile
                  quality_level           = h264_settings.value.quality_level
                  qvbr_quality_level      = h264_settings.value.qvbr_quality_level
                  rate_control_mode       = h264_settings.value.rate_control_mode
                  scan_type               = h264_settings.value.scan_type
                  scene_change_detect     = h264_settings.value.scene_change_detect
                  slices                  = h264_settings.value.slices
                  softness                = h264_settings.value.softness
                  spatial_aq              = h264_settings.value.spatial_aq
                  subgop_length           = h264_settings.value.subgop_length
                  syntax                  = h264_settings.value.syntax
                  temporal_aq             = h264_settings.value.temporal_aq
                  timecode_insertion      = h264_settings.value.timecode_insertion

                  dynamic "filter_settings" {
                    for_each = h264_settings.value.filter_settings != null ? [h264_settings.value.filter_settings] : []
                    content {
                      dynamic "temporal_filter_settings" {
                        for_each = filter_settings.value.temporal_filter_settings != null ? [filter_settings.value.temporal_filter_settings] : []
                        content {
                          post_filter_sharpening = temporal_filter_settings.value.post_filter_sharpening
                          strength               = temporal_filter_settings.value.strength
                        }
                      }
                    }
                  }
                }
              }

              dynamic "h265_settings" {
                for_each = codec_settings.value.h265_settings != null ? [codec_settings.value.h265_settings] : []
                content {
                  adaptive_quantization         = h265_settings.value.adaptive_quantization
                  afd_signaling                 = h265_settings.value.afd_signaling
                  alternative_transfer_function = h265_settings.value.alternative_transfer_function
                  bitrate                       = h265_settings.value.bitrate
                  buf_size                      = h265_settings.value.buf_size
                  color_metadata                = h265_settings.value.color_metadata
                  fixed_afd                     = h265_settings.value.fixed_afd
                  flicker_aq                    = h265_settings.value.flicker_aq
                  framerate_denominator         = h265_settings.value.framerate_denominator
                  framerate_numerator           = h265_settings.value.framerate_numerator
                  gop_closed_cadence            = h265_settings.value.gop_closed_cadence
                  gop_size                      = h265_settings.value.gop_size
                  gop_size_units                = h265_settings.value.gop_size_units
                  level                         = h265_settings.value.level
                  look_ahead_rate_control       = h265_settings.value.look_ahead_rate_control
                  max_bitrate                   = h265_settings.value.max_bitrate
                  min_i_interval                = h265_settings.value.min_i_interval
                  min_qp                        = h265_settings.value.min_qp
                  mv_over_picture_boundaries    = h265_settings.value.mv_over_picture_boundaries
                  mv_temporal_predictor         = h265_settings.value.mv_temporal_predictor
                  par_denominator               = h265_settings.value.par_denominator
                  par_numerator                 = h265_settings.value.par_numerator
                  profile                       = h265_settings.value.profile
                  qvbr_quality_level            = h265_settings.value.qvbr_quality_level
                  rate_control_mode             = h265_settings.value.rate_control_mode
                  scan_type                     = h265_settings.value.scan_type
                  scene_change_detect           = h265_settings.value.scene_change_detect
                  slices                        = h265_settings.value.slices
                  tier                          = h265_settings.value.tier
                  tile_height                   = h265_settings.value.tile_height
                  tile_padding                  = h265_settings.value.tile_padding
                  tile_width                    = h265_settings.value.tile_width
                  timecode_insertion            = h265_settings.value.timecode_insertion
                  treeblock_size                = h265_settings.value.treeblock_size

                  dynamic "color_space_settings" {
                    for_each = h265_settings.value.color_space_settings != null ? [h265_settings.value.color_space_settings] : []
                    content {
                      dynamic "color_space_passthrough_settings" {
                        for_each = color_space_settings.value.color_space_passthrough_settings != null ? [color_space_settings.value.color_space_passthrough_settings] : []
                        content {}
                      }

                      dynamic "dolby_vision81_settings" {
                        for_each = color_space_settings.value.dolby_vision81_settings != null ? [color_space_settings.value.dolby_vision81_settings] : []
                        content {}
                      }

                      dynamic "hdr10_settings" {
                        for_each = color_space_settings.value.hdr10_settings != null ? [color_space_settings.value.hdr10_settings] : []
                        content {
                          max_cll  = hdr10_settings.value.max_cll
                          max_fall = hdr10_settings.value.max_fall
                        }
                      }

                      dynamic "rec601_settings" {
                        for_each = color_space_settings.value.rec601_settings != null ? [color_space_settings.value.rec601_settings] : []
                        content {}
                      }

                      dynamic "rec709_settings" {
                        for_each = color_space_settings.value.rec709_settings != null ? [color_space_settings.value.rec709_settings] : []
                        content {}
                      }
                    }
                  }

                  dynamic "filter_settings" {
                    for_each = h265_settings.value.filter_settings != null ? [h265_settings.value.filter_settings] : []
                    content {
                      dynamic "temporal_filter_settings" {
                        for_each = filter_settings.value.temporal_filter_settings != null ? [filter_settings.value.temporal_filter_settings] : []
                        content {
                          post_filter_sharpening = temporal_filter_settings.value.post_filter_sharpening
                          strength               = temporal_filter_settings.value.strength
                        }
                      }
                    }
                  }

                  dynamic "timecode_burnin_settings" {
                    for_each = h265_settings.value.timecode_burnin_settings != null ? [h265_settings.value.timecode_burnin_settings] : []
                    content {
                      timecode_burnin_font_size = timecode_burnin_settings.value.timecode_burnin_font_size
                      timecode_burnin_position  = timecode_burnin_settings.value.timecode_burnin_position
                      prefix                    = timecode_burnin_settings.value.prefix
                    }
                  }
                }
              }
            }
          }
        }
      }

      dynamic "caption_descriptions" {
        for_each = encoder_settings.value.caption_descriptions != null ? encoder_settings.value.caption_descriptions : []
        content {
          caption_selector_name = caption_descriptions.value.caption_selector_name
          name                  = caption_descriptions.value.name
          accessibility         = caption_descriptions.value.accessibility
          language_code         = caption_descriptions.value.language_code
          language_description  = caption_descriptions.value.language_description

          dynamic "destination_settings" {
            for_each = caption_descriptions.value.destination_settings != null ? [caption_descriptions.value.destination_settings] : []
            content {
              dynamic "arib_destination_settings" {
                for_each = destination_settings.value.arib_destination_settings != null ? [destination_settings.value.arib_destination_settings] : []
                content {}
              }

              dynamic "burn_in_destination_settings" {
                for_each = destination_settings.value.burn_in_destination_settings != null ? [destination_settings.value.burn_in_destination_settings] : []
                content {
                  alignment             = burn_in_destination_settings.value.alignment
                  background_color      = burn_in_destination_settings.value.background_color
                  background_opacity    = burn_in_destination_settings.value.background_opacity
                  font_color            = burn_in_destination_settings.value.font_color
                  font_opacity          = burn_in_destination_settings.value.font_opacity
                  font_resolution       = burn_in_destination_settings.value.font_resolution
                  font_size             = burn_in_destination_settings.value.font_size
                  outline_color         = burn_in_destination_settings.value.outline_color
                  outline_size          = burn_in_destination_settings.value.outline_size
                  shadow_color          = burn_in_destination_settings.value.shadow_color
                  shadow_opacity        = burn_in_destination_settings.value.shadow_opacity
                  shadow_x_offset       = burn_in_destination_settings.value.shadow_x_offset
                  shadow_y_offset       = burn_in_destination_settings.value.shadow_y_offset
                  teletext_grid_control = burn_in_destination_settings.value.teletext_grid_control
                  x_position            = burn_in_destination_settings.value.x_position
                  y_position            = burn_in_destination_settings.value.y_position

                  dynamic "font" {
                    for_each = burn_in_destination_settings.value.font != null ? [burn_in_destination_settings.value.font] : []
                    content {
                      password_param = font.value.password_param
                      uri            = font.value.uri
                      username       = font.value.username
                    }
                  }
                }
              }

              dynamic "dvb_sub_destination_settings" {
                for_each = destination_settings.value.dvb_sub_destination_settings != null ? [destination_settings.value.dvb_sub_destination_settings] : []
                content {
                  alignment             = dvb_sub_destination_settings.value.alignment
                  background_color      = dvb_sub_destination_settings.value.background_color
                  background_opacity    = dvb_sub_destination_settings.value.background_opacity
                  font_color            = dvb_sub_destination_settings.value.font_color
                  font_opacity          = dvb_sub_destination_settings.value.font_opacity
                  font_resolution       = dvb_sub_destination_settings.value.font_resolution
                  font_size             = dvb_sub_destination_settings.value.font_size
                  outline_color         = dvb_sub_destination_settings.value.outline_color
                  outline_size          = dvb_sub_destination_settings.value.outline_size
                  shadow_color          = dvb_sub_destination_settings.value.shadow_color
                  shadow_opacity        = dvb_sub_destination_settings.value.shadow_opacity
                  shadow_x_offset       = dvb_sub_destination_settings.value.shadow_x_offset
                  shadow_y_offset       = dvb_sub_destination_settings.value.shadow_y_offset
                  teletext_grid_control = dvb_sub_destination_settings.value.teletext_grid_control
                  x_position            = dvb_sub_destination_settings.value.x_position
                  y_position            = dvb_sub_destination_settings.value.y_position

                  dynamic "font" {
                    for_each = dvb_sub_destination_settings.value.font != null ? [dvb_sub_destination_settings.value.font] : []
                    content {
                      password_param = font.value.password_param
                      uri            = font.value.uri
                      username       = font.value.username
                    }
                  }
                }
              }

              dynamic "ebu_tt_d_destination_settings" {
                for_each = destination_settings.value.ebu_tt_d_destination_settings != null ? [destination_settings.value.ebu_tt_d_destination_settings] : []
                content {
                  copyright_holder = ebu_tt_d_destination_settings.value.copyright_holder
                  fill_line_gap    = ebu_tt_d_destination_settings.value.fill_line_gap
                  font_family      = ebu_tt_d_destination_settings.value.font_family
                  style_control    = ebu_tt_d_destination_settings.value.style_control
                }
              }

              dynamic "embedded_destination_settings" {
                for_each = destination_settings.value.embedded_destination_settings != null ? [destination_settings.value.embedded_destination_settings] : []
                content {}
              }

              dynamic "embedded_plus_scte20_destination_settings" {
                for_each = destination_settings.value.embedded_plus_scte20_destination_settings != null ? [destination_settings.value.embedded_plus_scte20_destination_settings] : []
                content {}
              }

              dynamic "rtmp_caption_info_destination_settings" {
                for_each = destination_settings.value.rtmp_caption_info_destination_settings != null ? [destination_settings.value.rtmp_caption_info_destination_settings] : []
                content {}
              }

              dynamic "scte20_plus_embedded_destination_settings" {
                for_each = destination_settings.value.scte20_plus_embedded_destination_settings != null ? [destination_settings.value.scte20_plus_embedded_destination_settings] : []
                content {}
              }

              dynamic "scte27_destination_settings" {
                for_each = destination_settings.value.scte27_destination_settings != null ? [destination_settings.value.scte27_destination_settings] : []
                content {}
              }

              dynamic "smpte_tt_destination_settings" {
                for_each = destination_settings.value.smpte_tt_destination_settings != null ? [destination_settings.value.smpte_tt_destination_settings] : []
                content {}
              }

              dynamic "teletext_destination_settings" {
                for_each = destination_settings.value.teletext_destination_settings != null ? [destination_settings.value.teletext_destination_settings] : []
                content {}
              }

              dynamic "ttml_destination_settings" {
                for_each = destination_settings.value.ttml_destination_settings != null ? [destination_settings.value.ttml_destination_settings] : []
                content {
                  style_control = ttml_destination_settings.value.style_control
                }
              }

              dynamic "webvtt_destination_settings" {
                for_each = destination_settings.value.webvtt_destination_settings != null ? [destination_settings.value.webvtt_destination_settings] : []
                content {
                  style_control = webvtt_destination_settings.value.style_control
                }
              }
            }
          }
        }
      }

      dynamic "avail_blanking" {
        for_each = encoder_settings.value.avail_blanking != null ? [encoder_settings.value.avail_blanking] : []
        content {
          state = avail_blanking.value.state

          dynamic "avail_blanking_image" {
            for_each = avail_blanking.value.avail_blanking_image != null ? [avail_blanking.value.avail_blanking_image] : []
            content {
              uri            = avail_blanking_image.value.uri
              password_param = avail_blanking_image.value.password_param
              username       = avail_blanking_image.value.username
            }
          }
        }
      }

      dynamic "global_configuration" {
        for_each = encoder_settings.value.global_configuration != null ? [encoder_settings.value.global_configuration] : []
        content {
          initial_audio_gain           = global_configuration.value.initial_audio_gain
          input_end_action             = global_configuration.value.input_end_action
          output_locking_mode          = global_configuration.value.output_locking_mode
          output_timing_source         = global_configuration.value.output_timing_source
          support_low_framerate_inputs = global_configuration.value.support_low_framerate_inputs

          dynamic "input_loss_behavior" {
            for_each = global_configuration.value.input_loss_behavior != null ? [global_configuration.value.input_loss_behavior] : []
            content {
            }
          }
        }
      }

      dynamic "motion_graphics_configuration" {
        for_each = encoder_settings.value.motion_graphics_configuration != null ? [encoder_settings.value.motion_graphics_configuration] : []
        content {
          motion_graphics_insertion = motion_graphics_configuration.value.motion_graphics_insertion

          dynamic "motion_graphics_settings" {
            for_each = motion_graphics_configuration.value.motion_graphics_settings != null ? [motion_graphics_configuration.value.motion_graphics_settings] : []
            content {
              dynamic "html_motion_graphics_settings" {
                for_each = motion_graphics_settings.value.html_motion_graphics_settings != null ? [motion_graphics_settings.value.html_motion_graphics_settings] : []
                content {}
              }
            }
          }
        }
      }

      dynamic "nielsen_configuration" {
        for_each = encoder_settings.value.nielsen_configuration != null ? [encoder_settings.value.nielsen_configuration] : []
        content {
          distributor_id             = nielsen_configuration.value.distributor_id
          nielsen_pcm_to_id3_tagging = nielsen_configuration.value.nielsen_pcm_to_id3_tagging
        }
      }

      dynamic "output_groups" {
        for_each = encoder_settings.value.output_groups != null ? encoder_settings.value.output_groups : []
        content {
          name = output_groups.value.name

          dynamic "output_group_settings" {
            for_each = output_groups.value.output_group_settings != null ? [output_groups.value.output_group_settings] : []
            content {
              dynamic "archive_group_settings" {
                for_each = output_group_settings.value.archive_group_settings != null ? [output_group_settings.value.archive_group_settings] : []
                content {
                  rollover_interval = archive_group_settings.value.rollover_interval

                  dynamic "destination" {
                    for_each = archive_group_settings.value.destination != null ? [archive_group_settings.value.destination] : []
                    content {
                      destination_ref_id = destination.value.destination_ref_id
                    }
                  }

                  dynamic "archive_cdn_settings" {
                    for_each = archive_group_settings.value.archive_cdn_settings != null ? [archive_group_settings.value.archive_cdn_settings] : []
                    content {
                      dynamic "archive_s3_settings" {
                        for_each = archive_cdn_settings.value.archive_s3_settings != null ? [archive_cdn_settings.value.archive_s3_settings] : []
                        content {
                          canned_acl = archive_s3_settings.value.canned_acl
                        }
                      }
                    }
                  }
                }
              }

              dynamic "media_package_group_settings" {
                for_each = output_group_settings.value.media_package_group_settings != null ? [output_group_settings.value.media_package_group_settings] : []
                content {
                  dynamic "destination" {
                    for_each = media_package_group_settings.value.destination != null ? [media_package_group_settings.value.destination] : []
                    content {
                      destination_ref_id = destination.value.destination_ref_id
                    }
                  }
                }
              }

              dynamic "multiplex_group_settings" {
                for_each = output_group_settings.value.multiplex_group_settings != null ? [output_group_settings.value.multiplex_group_settings] : []
                content {}
              }

              dynamic "rtmp_group_settings" {
                for_each = output_group_settings.value.rtmp_group_settings != null ? [output_group_settings.value.rtmp_group_settings] : []
                content {
                  ad_markers            = rtmp_group_settings.value.ad_markers
                  authentication_scheme = rtmp_group_settings.value.authentication_scheme
                  cache_full_behavior   = rtmp_group_settings.value.cache_full_behavior
                  cache_length          = rtmp_group_settings.value.cache_length
                  caption_data          = rtmp_group_settings.value.caption_data
                  input_loss_action     = rtmp_group_settings.value.input_loss_action
                  restart_delay         = rtmp_group_settings.value.restart_delay
                }
              }

              dynamic "udp_group_settings" {
                for_each = output_group_settings.value.udp_group_settings != null ? [output_group_settings.value.udp_group_settings] : []
                content {
                  input_loss_action         = udp_group_settings.value.input_loss_action
                  timed_metadata_id3_frame  = udp_group_settings.value.timed_metadata_id3_frame
                  timed_metadata_id3_period = udp_group_settings.value.timed_metadata_id3_period
                }
              }
            }
          }

          dynamic "outputs" {
            for_each = output_groups.value.outputs != null ? output_groups.value.outputs : []
            content {
              output_name               = outputs.value.output_name
              audio_description_names   = outputs.value.audio_description_names
              caption_description_names = outputs.value.caption_description_names
              video_description_name    = outputs.value.video_description_name

              dynamic "output_settings" {
                for_each = outputs.value.output_settings != null ? [outputs.value.output_settings] : []
                content {
                  dynamic "archive_output_settings" {
                    for_each = output_settings.value.archive_output_settings != null ? [output_settings.value.archive_output_settings] : []
                    content {
                      extension     = archive_output_settings.value.extension
                      name_modifier = archive_output_settings.value.name_modifier

                      dynamic "container_settings" {
                        for_each = archive_output_settings.value.container_settings != null ? [archive_output_settings.value.container_settings] : []
                        content {
                          dynamic "m2ts_settings" {
                            for_each = container_settings.value.m2ts_settings != null ? [container_settings.value.m2ts_settings] : []
                            content {
                              # M2TS settings would go here but the documentation URL is referenced and not detailed in the markdown
                            }
                          }

                        }
                      }
                    }
                  }

                  dynamic "media_package_output_settings" {
                    for_each = output_settings.value.media_package_output_settings != null ? [output_settings.value.media_package_output_settings] : []
                    content {}
                  }

                  dynamic "multiplex_output_settings" {
                    for_each = output_settings.value.multiplex_output_settings != null ? [output_settings.value.multiplex_output_settings] : []
                    content {
                      dynamic "destination" {
                        for_each = multiplex_output_settings.value.destination != null ? [multiplex_output_settings.value.destination] : []
                        content {
                          destination_ref_id = destination.value.destination_ref_id
                        }
                      }
                    }
                  }

                  dynamic "rtmp_output_settings" {
                    for_each = output_settings.value.rtmp_output_settings != null ? [output_settings.value.rtmp_output_settings] : []
                    content {
                      certificate_mode          = rtmp_output_settings.value.certificate_mode
                      connection_retry_interval = rtmp_output_settings.value.connection_retry_interval
                      num_retries               = rtmp_output_settings.value.num_retries

                      dynamic "destination" {
                        for_each = rtmp_output_settings.value.destination != null ? [rtmp_output_settings.value.destination] : []
                        content {
                          destination_ref_id = destination.value.destination_ref_id
                        }
                      }
                    }
                  }

                  dynamic "udp_output_settings" {
                    for_each = output_settings.value.udp_output_settings != null ? [output_settings.value.udp_output_settings] : []
                    content {
                      buffer_msec = udp_output_settings.value.buffer_msec

                      dynamic "container_settings" {
                        for_each = udp_output_settings.value.container_settings != null ? [udp_output_settings.value.container_settings] : []
                        content {
                          dynamic "m2ts_settings" {
                            for_each = container_settings.value.m2ts_settings != null ? [container_settings.value.m2ts_settings] : []
                            content {
                              # M2TS settings would go here but the documentation URL is referenced and not detailed in the markdown
                            }
                          }

                        }
                      }

                      dynamic "destination" {
                        for_each = udp_output_settings.value.destination != null ? [udp_output_settings.value.destination] : []
                        content {
                          destination_ref_id = destination.value.destination_ref_id
                        }
                      }

                      dynamic "fec_output_settings" {
                        for_each = udp_output_settings.value.fec_output_settings != null ? [udp_output_settings.value.fec_output_settings] : []
                        content {
                          column_depth = fec_output_settings.value.column_depth
                          include_fec  = fec_output_settings.value.include_fec
                          row_length   = fec_output_settings.value.row_length
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  dynamic "vpc" {
    for_each = var.vpc != null ? [var.vpc] : []
    content {
      subnet_ids                    = vpc.value.subnet_ids
      public_address_allocation_ids = vpc.value.public_address_allocation_ids
      security_group_ids            = vpc.value.security_group_ids
    }
  }
}