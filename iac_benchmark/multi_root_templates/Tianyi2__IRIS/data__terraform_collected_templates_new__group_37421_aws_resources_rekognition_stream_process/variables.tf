variable "name" {
  description = "The name of the Stream Processor."
  type        = string
  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_rekognition_stream_processor, name must not be empty."
  }
}

variable "role_arn" {
  description = "The Amazon Resource Number (ARN) of the IAM role that allows access to the stream processor. The IAM role provides Rekognition read permissions for a Kinesis stream. It also provides write permissions to an Amazon S3 bucket and Amazon Simple Notification Service topic for a label detection stream processor. This is required for both face search and label detection stream processors."
  type        = string
  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/", var.role_arn))
    error_message = "resource_aws_rekognition_stream_processor, role_arn must be a valid IAM role ARN."
  }
}

variable "input" {
  description = "Input video stream."
  type = object({
    kinesis_video_stream = optional(object({
      arn = optional(string)
    }))
  })
  validation {
    condition     = var.input.kinesis_video_stream != null
    error_message = "resource_aws_rekognition_stream_processor, input must contain kinesis_video_stream configuration."
  }
  validation {
    condition = (
      var.input.kinesis_video_stream != null &&
      var.input.kinesis_video_stream.arn != null &&
      can(regex("^arn:aws[a-zA-Z-]*:kinesisvideo:", var.input.kinesis_video_stream.arn))
    )
    error_message = "resource_aws_rekognition_stream_processor, input.kinesis_video_stream.arn must be a valid Kinesis Video Stream ARN."
  }
}

variable "output" {
  description = "Kinesis data stream stream or Amazon S3 bucket location to which Amazon Rekognition Video puts the analysis results."
  type = object({
    kinesis_data_stream = optional(object({
      arn = optional(string)
    }))
    s3_destination = optional(object({
      bucket      = optional(string)
      key_prefixx = optional(string)
    }))
  })
  validation {
    condition = (
      (var.output.kinesis_data_stream != null && var.output.s3_destination == null) ||
      (var.output.kinesis_data_stream == null && var.output.s3_destination != null)
    )
    error_message = "resource_aws_rekognition_stream_processor, output must contain either kinesis_data_stream or s3_destination, but not both."
  }
  validation {
    condition = (
      var.output.kinesis_data_stream == null ||
      (var.output.kinesis_data_stream.arn != null && can(regex("^arn:aws[a-zA-Z-]*:kinesis:", var.output.kinesis_data_stream.arn)))
    )
    error_message = "resource_aws_rekognition_stream_processor, output.kinesis_data_stream.arn must be a valid Kinesis Data Stream ARN when specified."
  }
  validation {
    condition = (
      var.output.s3_destination == null ||
      (var.output.s3_destination.bucket != null && length(var.output.s3_destination.bucket) > 0)
    )
    error_message = "resource_aws_rekognition_stream_processor, output.s3_destination.bucket must not be empty when s3_destination is specified."
  }
}

variable "settings" {
  description = "Input parameters used in a streaming video analyzed by a stream processor."
  type = object({
    connected_home = optional(object({
      labels         = list(string)
      min_confidence = optional(number)
    }))
    face_search = optional(object({
      collection_id        = optional(string)
      face_match_threshold = optional(number)
    }))
  })
  validation {
    condition = (
      (var.settings.connected_home != null && var.settings.face_search == null) ||
      (var.settings.connected_home == null && var.settings.face_search != null)
    )
    error_message = "resource_aws_rekognition_stream_processor, settings must contain either connected_home or face_search, but not both."
  }
  validation {
    condition = (
      var.settings.connected_home == null ||
      length(var.settings.connected_home.labels) > 0
    )
    error_message = "resource_aws_rekognition_stream_processor, settings.connected_home.labels must not be empty when connected_home is specified."
  }
  validation {
    condition = (
      var.settings.connected_home == null ||
      alltrue([
        for label in var.settings.connected_home.labels :
        contains(["PERSON", "PET", "PACKAGE", "ALL"], label)
      ])
    )
    error_message = "resource_aws_rekognition_stream_processor, settings.connected_home.labels must contain only valid values: PERSON, PET, PACKAGE, ALL."
  }
  validation {
    condition = (
      var.settings.connected_home == null ||
      var.settings.connected_home.min_confidence == null ||
      (var.settings.connected_home.min_confidence >= 0 && var.settings.connected_home.min_confidence <= 100)
    )
    error_message = "resource_aws_rekognition_stream_processor, settings.connected_home.min_confidence must be between 0 and 100 when specified."
  }
  validation {
    condition = (
      var.settings.face_search == null ||
      var.settings.face_search.face_match_threshold == null ||
      (var.settings.face_search.face_match_threshold >= 0 && var.settings.face_search.face_match_threshold <= 100)
    )
    error_message = "resource_aws_rekognition_stream_processor, settings.face_search.face_match_threshold must be between 0 and 100 when specified."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "data_sharing_preference" {
  description = "Data sharing preference configuration."
  type = object({
    opt_in = optional(bool)
  })
  default = null
}

variable "kms_key_id" {
  description = "Optional parameter for label detection stream processors."
  type        = string
  default     = null
  validation {
    condition = (
      var.kms_key_id == null ||
      can(regex("^(arn:aws[a-zA-Z-]*:kms:|alias/|[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$)", var.kms_key_id))
    )
    error_message = "resource_aws_rekognition_stream_processor, kms_key_id must be a valid KMS key ID, ARN, or alias when specified."
  }
}

variable "notification_channel" {
  description = "The Amazon Simple Notification Service topic to which Amazon Rekognition publishes the completion status."
  type = object({
    sns_topic_arn = string
  })
  default = null
  validation {
    condition = (
      var.notification_channel == null ||
      can(regex("^arn:aws[a-zA-Z-]*:sns:", var.notification_channel.sns_topic_arn))
    )
    error_message = "resource_aws_rekognition_stream_processor, notification_channel.sns_topic_arn must be a valid SNS topic ARN when specified."
  }
}

variable "regions_of_interest" {
  description = "Specifies locations in the frames where Amazon Rekognition checks for objects or people."
  type = list(object({
    bounding_box = optional(object({
      height = number
      wight  = number
      left   = number
      top    = number
    }))
    polygon = optional(list(object({
      x = number
      y = number
    })))
  }))
  default = null
  validation {
    condition = (
      var.regions_of_interest == null ||
      alltrue([
        for roi in var.regions_of_interest :
        (roi.bounding_box != null && roi.polygon == null) ||
        (roi.bounding_box == null && roi.polygon != null)
      ])
    )
    error_message = "resource_aws_rekognition_stream_processor, regions_of_interest each region must contain either bounding_box or polygon, but not both."
  }
  validation {
    condition = (
      var.regions_of_interest == null ||
      alltrue([
        for roi in var.regions_of_interest :
        roi.bounding_box == null ||
        (roi.bounding_box.height >= 0 && roi.bounding_box.height <= 1 &&
          roi.bounding_box.wight >= 0 && roi.bounding_box.wight <= 1 &&
          roi.bounding_box.left >= 0 && roi.bounding_box.left <= 1 &&
        roi.bounding_box.top >= 0 && roi.bounding_box.top <= 1)
      ])
    )
    error_message = "resource_aws_rekognition_stream_processor, regions_of_interest bounding_box coordinates must be between 0 and 1."
  }
  validation {
    condition = (
      var.regions_of_interest == null ||
      alltrue([
        for roi in var.regions_of_interest :
        roi.polygon == null ||
        (length(roi.polygon) >= 3 && length(roi.polygon) <= 10)
      ])
    )
    error_message = "resource_aws_rekognition_stream_processor, regions_of_interest polygon must have between 3 and 10 points."
  }
  validation {
    condition = (
      var.regions_of_interest == null ||
      alltrue([
        for roi in var.regions_of_interest :
        roi.polygon == null ||
        alltrue([
          for point in roi.polygon :
          point.x >= 0 && point.x <= 1 && point.y >= 0 && point.y <= 1
        ])
      ])
    )
    error_message = "resource_aws_rekognition_stream_processor, regions_of_interest polygon coordinates must be between 0 and 1."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}