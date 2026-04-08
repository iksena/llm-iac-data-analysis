output "id" {
  description = "Partition id."
  value       = aws_glue_partition.this.id
}

output "creation_time" {
  description = "The time at which the partition was created."
  value       = aws_glue_partition.this.creation_time
}

output "last_analyzed_time" {
  description = "The last time at which column statistics were computed for this partition."
  value       = aws_glue_partition.this.last_analyzed_time
}

output "last_accessed_time" {
  description = "The last time at which the partition was accessed."
  value       = aws_glue_partition.this.last_accessed_time
}