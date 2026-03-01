provider "aws" {
  region = "us-west-2"
}

resource "aws_kinesis_video_stream" "example" {
  name = "example-video-stream"

  data_retention_in_hours = 24

  tags = {
    Environment = "dev"
    Project     = "VideoStreamProject"
  }
}