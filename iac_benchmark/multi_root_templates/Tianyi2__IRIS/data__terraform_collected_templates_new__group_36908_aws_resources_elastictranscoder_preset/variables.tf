variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "container" {
  description = "The container type for the output file."
  type        = string

  validation {
    condition     = contains(["flac", "flv", "fmp4", "gif", "mp3", "mp4", "mpg", "mxf", "oga", "ogg", "ts", "webm"], var.container)
    error_message = "resource_aws_elastictranscoder_preset, container must be one of: flac, flv, fmp4, gif, mp3, mp4, mpg, mxf, oga, ogg, ts, webm."
  }
}

variable "description" {
  description = "A description of the preset (maximum 255 characters)."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 255
    error_message = "resource_aws_elastictranscoder_preset, description must be 255 characters or less."
  }
}

variable "name" {
  description = "The name of the preset (maximum 40 characters)."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || length(var.name) <= 40
    error_message = "resource_aws_elastictranscoder_preset, name must be 40 characters or less."
  }
}

variable "audio" {
  description = "Audio parameters object."
  type = object({
    audio_packing_mode = optional(string)
    bit_rate           = optional(number)
    channels           = optional(number)
    codec              = optional(string)
    sample_rate        = optional(string)
  })
  default = null

  validation {
    condition = var.audio == null || (
      var.audio.codec == null || contains(["AAC", "flac", "mp2", "mp3", "pcm", "vorbis"], var.audio.codec)
    )
    error_message = "resource_aws_elastictranscoder_preset, audio codec must be one of: AAC, flac, mp2, mp3, pcm, vorbis."
  }

  validation {
    condition = var.audio == null || (
      var.audio.bit_rate == null || (var.audio.bit_rate >= 64 && var.audio.bit_rate <= 320)
    )
    error_message = "resource_aws_elastictranscoder_preset, audio bit_rate must be between 64 and 320, inclusive."
  }

  validation {
    condition = var.audio == null || (
      var.audio.sample_rate == null || contains(["auto", "22050", "32000", "44100", "48000", "96000"], var.audio.sample_rate)
    )
    error_message = "resource_aws_elastictranscoder_preset, audio sample_rate must be one of: auto, 22050, 32000, 44100, 48000, 96000."
  }
}

variable "audio_codec_options" {
  description = "Codec options for the audio parameters."
  type = object({
    bit_depth = optional(string)
    bit_order = optional(string)
    profile   = optional(string)
    signed    = optional(string)
  })
  default = null

  validation {
    condition = var.audio_codec_options == null || (
      var.audio_codec_options.bit_depth == null || contains(["16", "24"], var.audio_codec_options.bit_depth)
    )
    error_message = "resource_aws_elastictranscoder_preset, audio_codec_options bit_depth must be one of: 16, 24."
  }

  validation {
    condition = var.audio_codec_options == null || (
      var.audio_codec_options.bit_order == null || var.audio_codec_options.bit_order == "LittleEndian"
    )
    error_message = "resource_aws_elastictranscoder_preset, audio_codec_options bit_order must be LittleEndian."
  }

  validation {
    condition = var.audio_codec_options == null || (
      var.audio_codec_options.signed == null || var.audio_codec_options.signed == "Signed"
    )
    error_message = "resource_aws_elastictranscoder_preset, audio_codec_options signed must be Signed."
  }
}

variable "video" {
  description = "Video parameters object."
  type = object({
    aspect_ratio         = optional(string)
    bit_rate             = optional(string)
    codec                = optional(string)
    display_aspect_ratio = optional(string)
    fixed_gop            = optional(string)
    frame_rate           = optional(string)
    keyframes_max_dist   = optional(number)
    max_frame_rate       = optional(string)
    max_height           = optional(string)
    max_width            = optional(string)
    padding_policy       = optional(string)
    resolution           = optional(string)
    sizing_policy        = optional(string)
  })
  default = null

  validation {
    condition = var.video == null || (
      var.video.aspect_ratio == null || contains(["auto", "1:1", "4:3", "3:2", "16:9"], var.video.aspect_ratio)
    )
    error_message = "resource_aws_elastictranscoder_preset, video aspect_ratio must be one of: auto, 1:1, 4:3, 3:2, 16:9."
  }

  validation {
    condition = var.video == null || (
      var.video.codec == null || contains(["gif", "H.264", "mpeg2", "vp8", "vp9"], var.video.codec)
    )
    error_message = "resource_aws_elastictranscoder_preset, video codec must be one of: gif, H.264, mpeg2, vp8, vp9."
  }

  validation {
    condition = var.video == null || (
      var.video.display_aspect_ratio == null || contains(["auto", "1:1", "4:3", "3:2", "16:9"], var.video.display_aspect_ratio)
    )
    error_message = "resource_aws_elastictranscoder_preset, video display_aspect_ratio must be one of: auto, 1:1, 4:3, 3:2, 16:9."
  }

  validation {
    condition = var.video == null || (
      var.video.fixed_gop == null || contains(["true", "false"], var.video.fixed_gop)
    )
    error_message = "resource_aws_elastictranscoder_preset, video fixed_gop must be one of: true, false."
  }

  validation {
    condition = var.video == null || (
      var.video.frame_rate == null || contains(["auto", "10", "15", "23.97", "24", "25", "29.97", "30", "50", "60"], var.video.frame_rate)
    )
    error_message = "resource_aws_elastictranscoder_preset, video frame_rate must be one of: auto, 10, 15, 23.97, 24, 25, 29.97, 30, 50, 60."
  }

  validation {
    condition = var.video == null || (
      var.video.padding_policy == null || contains(["Pad", "NoPad"], var.video.padding_policy)
    )
    error_message = "resource_aws_elastictranscoder_preset, video padding_policy must be one of: Pad, NoPad."
  }

  validation {
    condition = var.video == null || (
      var.video.sizing_policy == null || contains(["Fit", "Fill", "Stretch", "Keep", "ShrinkToFit", "ShrinkToFill"], var.video.sizing_policy)
    )
    error_message = "resource_aws_elastictranscoder_preset, video sizing_policy must be one of: Fit, Fill, Stretch, Keep, ShrinkToFit, ShrinkToFill."
  }
}

variable "video_watermarks" {
  description = "Watermark parameters for the video parameters."
  type = list(object({
    horizontal_align  = optional(string)
    horizontal_offset = optional(string)
    id                = string
    max_height        = optional(string)
    max_width         = optional(string)
    opacity           = optional(string)
    sizing_policy     = optional(string)
    target            = optional(string)
    vertical_align    = optional(string)
    vertical_offset   = optional(string)
  }))
  default = []

  validation {
    condition     = length(var.video_watermarks) <= 4
    error_message = "resource_aws_elastictranscoder_preset, video_watermarks can have a maximum of 4 watermarks."
  }

  validation {
    condition = alltrue([
      for watermark in var.video_watermarks : length(watermark.id) <= 40
    ])
    error_message = "resource_aws_elastictranscoder_preset, video_watermarks id can be up to 40 characters long."
  }

  validation {
    condition = alltrue([
      for watermark in var.video_watermarks :
      watermark.sizing_policy == null || contains(["Fit", "Stretch", "ShrinkToFit"], watermark.sizing_policy)
    ])
    error_message = "resource_aws_elastictranscoder_preset, video_watermarks sizing_policy must be one of: Fit, Stretch, ShrinkToFit."
  }

  validation {
    condition = alltrue([
      for watermark in var.video_watermarks :
      watermark.target == null || contains(["Content", "Frame"], watermark.target)
    ])
    error_message = "resource_aws_elastictranscoder_preset, video_watermarks target must be one of: Content, Frame."
  }

  validation {
    condition = alltrue([
      for watermark in var.video_watermarks :
      watermark.vertical_align == null || contains(["Top", "Bottom", "Center"], watermark.vertical_align)
    ])
    error_message = "resource_aws_elastictranscoder_preset, video_watermarks vertical_align must be one of: Top, Bottom, Center."
  }
}

variable "video_codec_options" {
  description = "Codec options for the video parameters."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for key, value in var.video_codec_options :
      key != "Level" || contains(["1", "1b", "1.1", "1.2", "1.3", "2", "2.1", "2.2", "3", "3.1", "3.2", "4", "4.1"], value)
    ])
    error_message = "resource_aws_elastictranscoder_preset, video_codec_options Level must be one of: 1, 1b, 1.1, 1.2, 1.3, 2, 2.1, 2.2, 3, 3.1, 3.2, 4, 4.1."
  }

  validation {
    condition = alltrue([
      for key, value in var.video_codec_options :
      key != "MaxReferenceFrames" || can(tonumber(value)) && tonumber(value) >= 0 && tonumber(value) <= 16
    ])
    error_message = "resource_aws_elastictranscoder_preset, video_codec_options MaxReferenceFrames must be an integer between 0 and 16."
  }

  validation {
    condition = alltrue([
      for key, value in var.video_codec_options :
      key != "MaxBitRate" || value == "auto" || (can(tonumber(value)) && tonumber(value) >= 16 && tonumber(value) <= 62500)
    ])
    error_message = "resource_aws_elastictranscoder_preset, video_codec_options MaxBitRate must be 'auto' or an integer between 16 and 62500."
  }

  validation {
    condition = alltrue([
      for key, value in var.video_codec_options :
      key != "BufferSize" || (can(tonumber(value)) && tonumber(value) > 0)
    ])
    error_message = "resource_aws_elastictranscoder_preset, video_codec_options BufferSize must be an integer greater than 0."
  }

  validation {
    condition = alltrue([
      for key, value in var.video_codec_options :
      key != "ColorSpaceConversion" || contains(["None", "Bt709toBt601", "Bt601toBt709", "Auto"], value)
    ])
    error_message = "resource_aws_elastictranscoder_preset, video_codec_options ColorSpaceConversion must be one of: None, Bt709toBt601, Bt601toBt709, Auto."
  }

  validation {
    condition = alltrue([
      for key, value in var.video_codec_options :
      key != "ChromaSubsampling" || contains(["yuv420p", "yuv422p"], value)
    ])
    error_message = "resource_aws_elastictranscoder_preset, video_codec_options ChromaSubsampling must be one of: yuv420p, yuv422p."
  }

  validation {
    condition = alltrue([
      for key, value in var.video_codec_options :
      key != "LoopCount" || can(tonumber(value))
    ])
    error_message = "resource_aws_elastictranscoder_preset, video_codec_options LoopCount must be a valid number."
  }
}

variable "thumbnails" {
  description = "Thumbnail parameters object."
  type = object({
    aspect_ratio   = optional(string)
    format         = optional(string)
    interval       = optional(number)
    max_height     = optional(string)
    max_width      = optional(string)
    padding_policy = optional(string)
    resolution     = optional(string)
    sizing_policy  = optional(string)
  })
  default = null

  validation {
    condition = var.thumbnails == null || (
      var.thumbnails.aspect_ratio == null || contains(["auto", "1:1", "4:3", "3:2", "16:9"], var.thumbnails.aspect_ratio)
    )
    error_message = "resource_aws_elastictranscoder_preset, thumbnails aspect_ratio must be one of: auto, 1:1, 4:3, 3:2, 16:9."
  }

  validation {
    condition = var.thumbnails == null || (
      var.thumbnails.format == null || contains(["jpg", "png"], var.thumbnails.format)
    )
    error_message = "resource_aws_elastictranscoder_preset, thumbnails format must be one of: jpg, png."
  }

  validation {
    condition = var.thumbnails == null || (
      var.thumbnails.padding_policy == null || contains(["Pad", "NoPad"], var.thumbnails.padding_policy)
    )
    error_message = "resource_aws_elastictranscoder_preset, thumbnails padding_policy must be one of: Pad, NoPad."
  }

  validation {
    condition = var.thumbnails == null || (
      var.thumbnails.sizing_policy == null || contains(["Fit", "Fill", "Stretch", "Keep", "ShrinkToFit", "ShrinkToFill"], var.thumbnails.sizing_policy)
    )
    error_message = "resource_aws_elastictranscoder_preset, thumbnails sizing_policy must be one of: Fit, Fill, Stretch, Keep, ShrinkToFit, ShrinkToFill."
  }
}