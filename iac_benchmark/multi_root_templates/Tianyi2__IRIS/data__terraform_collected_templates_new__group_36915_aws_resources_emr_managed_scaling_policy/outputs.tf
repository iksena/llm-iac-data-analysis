output "cluster_id" {
  description = "The EMR cluster ID associated with the managed scaling policy"
  value       = aws_emr_managed_scaling_policy.this.cluster_id
}