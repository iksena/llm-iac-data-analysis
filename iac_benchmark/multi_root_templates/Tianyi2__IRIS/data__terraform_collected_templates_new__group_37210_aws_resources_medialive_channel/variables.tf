variable "name" {
  description = "Name of the Channel."
  type        = string
}

variable "channel_class" {
  description = "Concise argument description."
  type        = string
  validation {
    condition     = contains(["STANDARD", "SINGLE_PIPELINE"], var.channel_class)
    error_message = "resource_aws_medialive_channel, channel_class must be one of: STANDARD, SINGLE_PIPELINE."
  }
}

variable "destinations" {
  description = "Destinations for channel."
  type = list(object({
    id = string
    media_package_settings = optional(object({
      channel_id = string
    }))
    multiplex_settings = optional(object({
      multiplex_id = string
      program_name = optional(string)
    }))
    settings = optional(list(object({
      password_param = optional(string)
      stream_name    = optional(string)
      url            = optional(string)
      username       = optional(string)
    })))
  }))
}

variable "encoder_settings" {
  description = "Encoder settings."
  type = object({
    output_groups = list(object({
      name = optional(string)
      output_group_settings = object({
        archive_group_settings = optional(object({
          destination = object({
            destination_ref_id = string
          })
          archive_cdn_settings = optional(object({
            archive_s3_settings = optional(object({
              canned_acl = optional(string)
            }))
          }))
          rollover_interval = optional(number)
        }))
        media_package_group_settings = optional(object({
          destination = object({
            destination_ref_id = string
          })
        }))
        multiplex_group_settings = optional(object({}))
        rtmp_group_settings = optional(object({
          ad_markers            = optional(string)
          authentication_scheme = optional(string)
          cache_full_behavior   = optional(string)
          cache_length          = optional(number)
          caption_data          = optional(string)
          input_loss_action     = optional(string)
          restart_delay         = optional(number)
        }))
        udp_group_settings = optional(object({
          input_loss_action         = optional(string)
          timed_metadata_id3_frame  = optional(string)
          timed_metadata_id3_period = optional(number)
        }))
      })
      outputs = list(object({
        output_name               = string
        audio_description_names   = optional(list(string))
        caption_description_names = optional(list(string))
        video_description_name    = optional(string)
        output_settings = object({
          archive_output_settings = optional(object({
            extension     = optional(string)
            name_modifier = optional(string)
            container_settings = object({
              m2ts_settings = optional(object({}))
              raw_settings  = optional(object({}))
            })
          }))
          media_package_output_settings = optional(object({}))
          multiplex_output_settings = optional(object({
            destination = object({
              destination_ref_id = string
            })
          }))
          rtmp_output_settings = optional(object({
            certificate_mode          = optional(string)
            connection_retry_interval = optional(number)
            num_retries               = optional(number)
            destination = object({
              destination_ref_id = string
            })
          }))
          udp_output_settings = optional(object({
            buffer_msec = optional(number)
            container_settings = object({
              m2ts_settings = optional(object({}))
              raw_settings  = optional(object({}))
            })
            destination = object({
              destination_ref_id = string
            })
            fec_output_settings = optional(object({
              column_depth = optional(number)
              include_fec  = optional(string)
              row_length   = optional(number)
            }))
          }))
        })
      }))
    }))
    timecode_config = object({
      source         = optional(string)
      sync_threshold = optional(number)
    })
    video_descriptions = list(object({
      name             = string
      height           = optional(number)
      respond_to_afd   = optional(string)
      scaling_behavior = optional(string)
      sharpness        = optional(number)
      width            = optional(number)
      codec_settings = optional(object({
        frame_capture_settings = optional(object({
          capture_interval       = optional(number)
          capture_interval_units = optional(string)
        }))
        h264_settings = optional(object({
          adaptive_quantization   = optional(string)
          afd_signaling           = optional(string)
          bitrate                 = optional(number)
          buf_fil_pct             = optional(number)
          buf_size                = optional(number)
          color_metadata          = optional(string)
          entropy_encoding        = optional(string)
          fixed_afd               = optional(string)
          flicer_aq               = optional(string)
          force_field_pictures    = optional(string)
          framerate_control       = optional(string)
          framerate_denominator   = optional(number)
          framerate_numerator     = optional(number)
          gop_b_reference         = optional(string)
          gop_closed_cadence      = optional(number)
          gop_num_b_frames        = optional(number)
          gop_size                = optional(number)
          gop_size_units          = optional(string)
          level                   = optional(string)
          look_ahead_rate_control = optional(string)
          max_bitrate             = optional(number)
          min_interval            = optional(number)
          num_ref_frames          = optional(number)
          par_control             = optional(string)
          par_denominator         = optional(number)
          par_numerator           = optional(number)
          profile                 = optional(string)
          quality_level           = optional(string)
          qvbr_quality_level      = optional(number)
          rate_control_mode       = optional(string)
          scan_type               = optional(string)
          scene_change_detect     = optional(string)
          slices                  = optional(number)
          softness                = optional(number)
          spatial_aq              = optional(string)
          subgop_length           = optional(string)
          syntax                  = optional(string)
          temporal_aq             = optional(string)
          timecode_insertion      = optional(string)
          filter_settings = optional(object({
            temporal_filter_settings = optional(object({
              post_filter_sharpening = optional(string)
              strength               = optional(string)
            }))
          }))
        }))
        h265_settings = optional(object({
          adaptive_quantization         = optional(string)
          afd_signaling                 = optional(string)
          alternative_transfer_function = optional(string)
          bitrate                       = number
          buf_size                      = optional(number)
          color_metadata                = optional(string)
          fixed_afd                     = optional(string)
          flicer_aq                     = optional(string)
          framerate_denominator         = number
          framerate_numerator           = number
          gop_closed_cadence            = optional(number)
          gop_size                      = optional(number)
          gop_size_units                = optional(string)
          level                         = optional(string)
          look_ahead_rate_control       = optional(string)
          max_bitrate                   = optional(number)
          min_i_interval                = optional(number)
          min_qp                        = optional(number)
          mv_over_picture_boundaries    = optional(string)
          mv_temporal_predictor         = optional(string)
          par_denominator               = optional(number)
          par_numerator                 = optional(number)
          profile                       = optional(string)
          qvbr_quality_level            = optional(number)
          rate_control_mode             = optional(string)
          scan_type                     = optional(string)
          scene_change_detect           = optional(string)
          slices                        = optional(number)
          tier                          = optional(string)
          tile_height                   = optional(number)
          tile_padding                  = optional(string)
          tile_width                    = optional(number)
          timecode_insertion            = optional(string)
          treeblock_size                = optional(string)
          color_space_settings = optional(object({
            color_space_passthrough_settings = optional(object({}))
            dolby_vision81_settings          = optional(object({}))
            hdr10_settings = optional(object({
              max_cll  = optional(number)
              max_fall = optional(number)
            }))
            rec601_settings = optional(object({}))
            rec709_settings = optional(object({}))
          }))
          filter_settings = optional(object({
            temporal_filter_settings = optional(object({
              post_filter_sharpening = optional(string)
              strength               = optional(string)
            }))
          }))
          timecode_burnin_settings = optional(object({
            timecode_burnin_font_size = optional(string)
            timecode_burnin_position  = optional(string)
            prefix                    = optional(string)
          }))
        }))
      }))
    }))
    audio_descriptions = optional(list(object({
      audio_selector_name = string
      name                = string
      audio_type          = optional(string)
      audio_type_control  = optional(string)
      audio_normalization_settings = optional(object({
        algorithm         = optional(string)
        algorithm_control = optional(string)
        target_lkfs       = optional(number)
      }))
      audio_watermark_settings = optional(object({
        nielsen_watermark_settings = optional(object({
          nielsen_distribution_type = optional(string)
          nielsen_cbet_settings = optional(object({
            cbet_check_digit = string
            cbet_stepaside   = string
            csid             = string
          }))
          nielsen_naes_ii_nw_settings = optional(object({
            check_digit = string
            sid         = string
          }))
        }))
      }))
      codec_settings = optional(object({
        aac_settings = optional(object({
          bitrate           = optional(number)
          coding_mode       = optional(string)
          input_type        = optional(string)
          profile           = optional(string)
          rate_control_mode = optional(string)
          raw_format        = optional(string)
          sample_rate       = optional(number)
          spec              = optional(string)
          vbr_quality       = optional(string)
        }))
        ac3_settings = optional(object({
          bitrate          = optional(number)
          bitstream_mode   = optional(string)
          coding_mode      = optional(string)
          dialnorm         = optional(number)
          drc_profile      = optional(string)
          lfe_filter       = optional(string)
          metadata_control = optional(string)
        }))
        eac3_atmos_settings = optional(object({
          bitrate       = optional(number)
          coding_mode   = optional(string)
          dialnorm      = optional(number)
          drc_line      = optional(string)
          drc_rf        = optional(string)
          height_trim   = optional(number)
          surround_trim = optional(number)
        }))
        eac3_settings = optional(object({
          attenuation_control = optional(string)
          bitrate             = optional(number)
          bitstream_mode      = optional(string)
          coding_mode         = optional(string)
        }))
      }))
    })))
    avail_blanking = optional(object({
      state = optional(string)
      avail_blanking_image = optional(object({
        uri            = string
        password_param = optional(string)
        username       = optional(string)
      }))
    }))
    caption_descriptions = optional(list(object({
      caption_selector_name = string
      name                  = string
      accessibility         = optional(string)
      language_code         = optional(string)
      language_description  = optional(string)
      destination_settings = optional(object({
        arib_destination_settings = optional(object({}))
        burn_in_destination_settings = optional(object({
          alignment             = optional(string)
          background_color      = optional(string)
          background_opacity    = optional(number)
          font_color            = optional(string)
          font_opacity          = optional(number)
          font_resolution       = optional(number)
          font_size             = optional(string)
          outline_color         = optional(string)
          outline_size          = optional(number)
          shadow_color          = optional(string)
          shadow_opacity        = optional(number)
          shadow_x_offset       = optional(number)
          shadow_y_offset       = optional(number)
          teletext_grid_control = optional(string)
          x_position            = optional(number)
          y_position            = optional(number)
          font = optional(object({
            password_param = optional(string)
            uri            = string
            username       = optional(string)
          }))
        }))
        dvb_sub_destination_settings = optional(object({
          alignment             = optional(string)
          background_color      = optional(string)
          background_opacity    = optional(number)
          font_color            = optional(string)
          font_opacity          = optional(number)
          font_resolution       = optional(number)
          font_size             = optional(string)
          outline_color         = optional(string)
          outline_size          = optional(number)
          shadow_color          = optional(string)
          shadow_opacity        = optional(number)
          shadow_x_offset       = optional(number)
          shadow_y_offset       = optional(number)
          teletext_grid_control = optional(string)
          x_position            = optional(number)
          y_position            = optional(number)
          font = optional(object({
            password_param = optional(string)
            uri            = string
            username       = optional(string)
          }))
        }))
        ebu_tt_d_destination_settings = optional(object({
          copyright_holder = optional(string)
          fill_line_gap    = optional(string)
          font_family      = optional(string)
          style_control    = optional(string)
        }))
        embedded_destination_settings             = optional(object({}))
        embedded_plus_scte20_destination_settings = optional(object({}))
        rtmp_caption_info_destination_settings    = optional(object({}))
        scte20_plus_embedded_destination_settings = optional(object({}))
        scte27_destination_settings               = optional(object({}))
        smpte_tt_destination_settings             = optional(object({}))
        teletext_destination_settings             = optional(object({}))
        ttml_destination_settings = optional(object({
          style_control = optional(string)
        }))
        webvtt_destination_settings = optional(object({
          style_control = optional(string)
        }))
      }))
    })))
    global_configuration = optional(object({
      initial_audio_gain           = optional(number)
      input_end_action             = optional(string)
      output_locking_mode          = optional(string)
      output_timing_source         = optional(string)
      support_low_framerate_inputs = optional(string)
      input_loss_behavior = optional(object({
        password_param = optional(string)
        uri            = string
        username       = optional(string)
      }))
    }))
    motion_graphics_configuration = optional(object({
      motion_graphics_insertion = optional(string)
      motion_graphics_settings = object({
        html_motion_graphics_settings = optional(object({}))
      })
    }))
    nielsen_configuration = optional(object({
      distributor_id             = optional(string)
      nielsen_pcm_to_id3_tagging = optional(string)
    }))
  })
}

variable "input_specification" {
  description = "Specification of network and file inputs for the channel."
  type = object({
    codec            = string
    input_resolution = string
    maximum_bitrate  = string
  })
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cdi_input_specification" {
  description = "Specification of CDI inputs for this channel."
  type = object({
    resolution = string
  })
  default = null
  validation {
    condition     = var.cdi_input_specification == null || contains(["HD", "FHD", "UHD"], var.cdi_input_specification.resolution)
    error_message = "resource_aws_medialive_channel, cdi_input_specification.resolution must be one of: HD, FHD, UHD."
  }
}

variable "input_attachments" {
  description = "Input attachments for the channel."
  type = list(object({
    input_attachment_name = optional(string)
    input_id              = string
    input_settings = optional(object({
      deblock_filter            = optional(string)
      denoise_filter            = optional(string)
      filter_strength           = optional(number)
      input_filter              = optional(string)
      scte35_pid                = optional(number)
      smpte2038_data_preference = optional(string)
      source_end_behavior       = optional(string)
      audio_selector = optional(list(object({
        name = string
        selector_settings = optional(object({
          audio_hls_rendition_selection = optional(object({
            group_id = string
            name     = string
          }))
          audio_language_selection = optional(object({
            language_code             = string
            language_selection_policy = optional(string)
          }))
          audio_pid_selection = optional(object({
            pid = number
          }))
          audio_track_selection = optional(object({
            tracks = list(object({
              track = number
            }))
            dolby_e_decode = optional(object({
              program_selection = string
            }))
          }))
        }))
      })))
      caption_selector = optional(list(object({
        name          = optional(string)
        language_code = optional(string)
        selector_settings = optional(object({
          ancillary_source_settings = optional(object({
            source_ancillary_channel_number = optional(number)
          }))
          arib_source_settings = optional(object({}))
          dvb_sub_source_settings = optional(object({
            ocr_language = optional(string)
            pid          = optional(number)
          }))
          embedded_source_settings = optional(object({
            convert_608_to_708        = optional(string)
            scte20_detection          = optional(string)
            source_608_channel_number = optional(number)
          }))
          scte20_source_settings = optional(object({
            convert_608_to_708        = optional(string)
            source_608_channel_number = optional(number)
          }))
          scte27_source_settings = optional(object({
            ocr_language = optional(string)
            pid          = optional(number)
          }))
          teletext_source_settings = optional(object({
            page_number = optional(string)
            output_rectangle = optional(object({
              height      = number
              left_offset = number
              top_offset  = number
              width       = number
            }))
          }))
        }))
      })))
      network_input_settings = optional(object({
        server_validation = optional(string)
        hls_input_settings = optional(object({
          bandwidth          = optional(number)
          buffer_segments    = optional(number)
          retries            = optional(number)
          retry_interval     = optional(number)
          scte35_source_type = optional(string)
        }))
      }))
    }))
    automatic_input_failover_settings = optional(object({
      secondary_input_id    = string
      error_clear_time_msec = optional(number)
      input_preference      = optional(string)
      failover_condition = optional(list(object({
        failover_condition_settings = optional(object({
          audio_silence_settings = optional(object({
            audio_selector_name          = string
            audio_silence_threshold_msec = optional(number)
          }))
          input_loss_settings = optional(object({
            input_loss_threshold_msec = optional(number)
          }))
          video_black_settings = optional(object({
            black_detect_threshold     = optional(number)
            video_black_threshold_msec = optional(number)
          }))
        }))
      })))
    }))
  }))
  default = []
  validation {
    condition = alltrue([
      for attachment in var.input_attachments : (
        attachment.input_settings == null || attachment.input_settings.filter_strength == null || (
          attachment.input_settings.filter_strength >= 1 && attachment.input_settings.filter_strength <= 5
        )
      )
    ])
    error_message = "resource_aws_medialive_channel, input_attachments.input_settings.filter_strength must be between 1 and 5."
  }
}

variable "log_level" {
  description = "The log level to write to Cloudwatch logs."
  type        = string
  default     = null
  validation {
    condition     = var.log_level == null || contains(["ERROR", "WARNING", "INFO", "DEBUG", "DISABLED"], var.log_level)
    error_message = "resource_aws_medialive_channel, log_level must be one of: ERROR, WARNING, INFO, DEBUG, DISABLED."
  }
}

variable "maintenance" {
  description = "Maintenance settings for this channel."
  type = object({
    maintenance_day        = optional(string)
    maintenance_start_time = optional(string)
  })
  default = null
  validation {
    condition = var.maintenance == null || var.maintenance.maintenance_day == null || contains([
      "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"
    ], var.maintenance.maintenance_day)
    error_message = "resource_aws_medialive_channel, maintenance.maintenance_day must be one of: MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY."
  }
}

variable "role_arn" {
  description = "Concise argument description."
  type        = string
  default     = null
}

variable "start_channel" {
  description = "Whether to start/stop channel. Default: false"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the channel."
  type        = map(string)
  default     = {}
}

variable "vpc" {
  description = "Settings for the VPC outputs."
  type = object({
    subnet_ids                    = list(string)
    public_address_allocation_ids = list(string)
    security_group_ids            = optional(list(string))
  })
  default = null
  validation {
    condition = var.vpc == null || (
      length(var.vpc.subnet_ids) >= 1 && length(var.vpc.public_address_allocation_ids) >= 1
    )
    error_message = "resource_aws_medialive_channel, vpc.subnet_ids and vpc.public_address_allocation_ids must contain at least one element."
  }
}