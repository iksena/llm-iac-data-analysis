output "create_time" {
  description = "The timestamp for when the place index resource was created in ISO 8601 format"
  value       = aws_location_place_index.this.create_time
}

output "index_arn" {
  description = "The Amazon Resource Name (ARN) for the place index resource. Used to specify a resource across AWS"
  value       = aws_location_place_index.this.index_arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_location_place_index.this.tags_all
}

output "update_time" {
  description = "The timestamp for when the place index resource was last update in ISO 8601"
  value       = aws_location_place_index.this.update_time
}