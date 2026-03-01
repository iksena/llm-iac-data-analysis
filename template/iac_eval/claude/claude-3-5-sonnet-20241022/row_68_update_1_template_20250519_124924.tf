provider "aws" {
  region = "us-east-1"
}

# Create IAM role for Kinesis Video Stream
resource "aws_iam_role" "kinesis_video_stream_role" {
  name = "kinesis-video-stream-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "kinesisvideo.amazonaws.com"
        }
      }
    ]
  })
}

# Create IAM policy for Kinesis Video Stream
resource "aws_iam_role_policy" "kinesis_video_stream_policy" {
  name = "kinesis-video-stream-policy"
  role = aws_iam_role.kinesis_video_stream_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kinesisvideo:*"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create Kinesis Video Stream
resource "aws_kinesis_video_stream" "example_stream" {
  name                    = "example-stream"
  data_retention_in_hours = 24
  device_name            = "example-device"
  media_type             = "video/h264"
  
  tags = {
    Environment = "production"
    Purpose     = "video-streaming"
  }
}

# Output the Stream ARN
output "stream_arn" {
  value = aws_kinesis_video_stream.example_stream.arn
}

# Output the Stream Name
output "stream_name" {
  value = aws_kinesis_video_stream.example_stream.name
}