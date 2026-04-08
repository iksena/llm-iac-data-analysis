output "arn" {
  description = "ARN of the Collection."
  value       = aws_rekognition_collection.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_rekognition_collection.this.tags_all
}

output "face_model_version" {
  description = "The Face Model Version that the collection was initialized with"
  value       = aws_rekognition_collection.this.face_model_version
}

output "collection_id" {
  description = "The name of the collection"
  value       = aws_rekognition_collection.this.collection_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_rekognition_collection.this.region
}

output "tags" {
  description = "Map of tags assigned to the resource"
  value       = aws_rekognition_collection.this.tags
}