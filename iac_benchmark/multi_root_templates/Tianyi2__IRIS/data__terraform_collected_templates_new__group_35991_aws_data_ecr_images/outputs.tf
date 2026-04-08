output "image_ids" {
  description = "List of image objects containing image digest and tags. Each object has image_digest and image_tag attributes."
  value       = data.aws_ecr_images.this.image_ids
}