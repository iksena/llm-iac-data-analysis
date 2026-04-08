output "id" {
  description = "SHA256 digest of the image manifest."
  value       = data.aws_ecr_image.this.id
}

output "image_pushed_at" {
  description = "Date and time, expressed as a unix timestamp, at which the current image was pushed to the repository."
  value       = data.aws_ecr_image.this.image_pushed_at
}

output "image_size_in_bytes" {
  description = "Size, in bytes, of the image in the repository."
  value       = data.aws_ecr_image.this.image_size_in_bytes
}

output "image_tags" {
  description = "List of tags associated with this image."
  value       = data.aws_ecr_image.this.image_tags
}

output "image_uri" {
  description = "The URI for the specific image version specified by image_tag or image_digest."
  value       = data.aws_ecr_image.this.image_uri
}