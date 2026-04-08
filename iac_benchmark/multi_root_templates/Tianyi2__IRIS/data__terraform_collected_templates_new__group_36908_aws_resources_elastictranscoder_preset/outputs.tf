output "arn" {
  description = "Amazon Resource Name (ARN) of the Elastic Transcoder Preset."
  value       = aws_elastictranscoder_preset.this.arn
}

output "id" {
  description = "The ID of the Elastic Transcoder Preset."
  value       = aws_elastictranscoder_preset.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_elastictranscoder_preset.this.region
}

output "container" {
  description = "The container type for the output file."
  value       = aws_elastictranscoder_preset.this.container
}

output "description" {
  description = "A description of the preset."
  value       = aws_elastictranscoder_preset.this.description
}

output "name" {
  description = "The name of the preset."
  value       = aws_elastictranscoder_preset.this.name
}

output "audio" {
  description = "Audio parameters object."
  value       = aws_elastictranscoder_preset.this.audio
}

output "audio_codec_options" {
  description = "Codec options for the audio parameters."
  value       = aws_elastictranscoder_preset.this.audio_codec_options
}

output "video" {
  description = "Video parameters object."
  value       = aws_elastictranscoder_preset.this.video
}

output "video_watermarks" {
  description = "Watermark parameters for the video parameters."
  value       = aws_elastictranscoder_preset.this.video_watermarks
}

output "video_codec_options" {
  description = "Codec options for the video parameters."
  value       = aws_elastictranscoder_preset.this.video_codec_options
}

output "thumbnails" {
  description = "Thumbnail parameters object."
  value       = aws_elastictranscoder_preset.this.thumbnails
}