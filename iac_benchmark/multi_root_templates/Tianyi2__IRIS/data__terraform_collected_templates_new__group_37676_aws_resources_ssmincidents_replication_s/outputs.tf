output "arn" {
  description = "The ARN of the replication set"
  value       = aws_ssmincidents_replication_set.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_ssmincidents_replication_set.this.tags_all
}

output "created_by" {
  description = "The ARN of the user who created the replication set"
  value       = aws_ssmincidents_replication_set.this.created_by
}


output "deletion_protected" {
  description = "If true, the last region in a replication set cannot be deleted"
  value       = aws_ssmincidents_replication_set.this.deletion_protected
}

output "last_modified_by" {
  description = "A timestamp showing when the replication set was last modified"
  value       = aws_ssmincidents_replication_set.this.last_modified_by
}


output "status" {
  description = "The overall status of a replication set"
  value       = aws_ssmincidents_replication_set.this.status
}

output "regions" {
  description = "The replication set's regions with their status information"
  value = [
    for region in aws_ssmincidents_replication_set.this.regions : {
      name               = region.name
      kms_key_arn        = region.kms_key_arn
      status             = region.status
      status_update_time = region.status_update_time
      status_message     = region.status_message
    }
  ]
}