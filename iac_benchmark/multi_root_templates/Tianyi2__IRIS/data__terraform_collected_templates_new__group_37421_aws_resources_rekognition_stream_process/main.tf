resource "aws_rekognition_stream_processor" "this" {
  name     = var.name
  role_arn = var.role_arn

  input {
    dynamic "kinesis_video_stream" {
      for_each = var.input.kinesis_video_stream != null ? [var.input.kinesis_video_stream] : []
      content {
        arn = kinesis_video_stream.value.arn
      }
    }
  }

  output {
    dynamic "kinesis_data_stream" {
      for_each = var.output.kinesis_data_stream != null ? [var.output.kinesis_data_stream] : []
      content {
        arn = kinesis_data_stream.value.arn
      }
    }

    dynamic "s3_destination" {
      for_each = var.output.s3_destination != null ? [var.output.s3_destination] : []
      content {
        bucket     = s3_destination.value.bucket
        key_prefix = s3_destination.value.key_prefix
      }
    }
  }

  settings {
    dynamic "connected_home" {
      for_each = var.settings.connected_home != null ? [var.settings.connected_home] : []
      content {
        labels         = connected_home.value.labels
        min_confidence = connected_home.value.min_confidence
      }
    }

    dynamic "face_search" {
      for_each = var.settings.face_search != null ? [var.settings.face_search] : []
      content {
        collection_id        = face_search.value.collection_id
        face_match_threshold = face_search.value.face_match_threshold
      }
    }
  }

  region     = var.region
  kms_key_id = var.kms_key_id

  dynamic "data_sharing_preference" {
    for_each = var.data_sharing_preference != null ? [var.data_sharing_preference] : []
    content {
      opt_in = data_sharing_preference.value.opt_in
    }
  }

  dynamic "notification_channel" {
    for_each = var.notification_channel != null ? [var.notification_channel] : []
    content {
      sns_topic_arn = notification_channel.value.sns_topic_arn
    }
  }

  dynamic "regions_of_interest" {
    for_each = var.regions_of_interest != null ? var.regions_of_interest : []
    content {
      dynamic "bounding_box" {
        for_each = regions_of_interest.value.bounding_box != null ? [regions_of_interest.value.bounding_box] : []
        content {
          height = bounding_box.value.height
          width  = bounding_box.value.width
          left   = bounding_box.value.left
          top    = bounding_box.value.top
        }
      }

      dynamic "polygon" {
        for_each = regions_of_interest.value.polygon != null ? regions_of_interest.value.polygon : []
        content {
          x = polygon.value.x
          y = polygon.value.y
        }
      }
    }
  }

  tags = var.tags

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}