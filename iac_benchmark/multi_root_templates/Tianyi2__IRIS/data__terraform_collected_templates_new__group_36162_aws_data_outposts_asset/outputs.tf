output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_outposts_asset.this.region
}

output "arn" {
  description = "Outpost ARN."
  value       = data.aws_outposts_asset.this.arn
}

output "asset_id" {
  description = "ID of the asset."
  value       = data.aws_outposts_asset.this.asset_id
}

output "asset_type" {
  description = "Type of the asset."
  value       = data.aws_outposts_asset.this.asset_type
}

output "host_id" {
  description = "Host ID of the Dedicated Hosts on the asset, if a Dedicated Host is provisioned."
  value       = data.aws_outposts_asset.this.host_id
}

output "rack_elevation" {
  description = "Position of an asset in a rack measured in rack units."
  value       = data.aws_outposts_asset.this.rack_elevation
}

output "rack_id" {
  description = "Rack ID of the asset."
  value       = data.aws_outposts_asset.this.rack_id
}