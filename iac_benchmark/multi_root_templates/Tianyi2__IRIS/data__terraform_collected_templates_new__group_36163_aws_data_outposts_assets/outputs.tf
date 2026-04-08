output "asset_ids" {
  description = "List of all the asset ids found. This data source will fail if none are found."
  value       = data.aws_outposts_assets.this.asset_ids
}

output "arn" {
  description = "Outpost ARN."
  value       = data.aws_outposts_assets.this.arn
}

output "host_id_filter" {
  description = "Filters by list of Host IDs of a Dedicated Host."
  value       = data.aws_outposts_assets.this.host_id_filter
}

output "status_id_filter" {
  description = "Filters by list of state status."
  value       = data.aws_outposts_assets.this.status_id_filter
}