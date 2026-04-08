output "ids" {
  description = "List of AMI IDs, sorted by creation time according to sort_ascending."
  value       = data.aws_ami_ids.this.ids
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_ami_ids.this.region
}

output "owners" {
  description = "List of AMI owners used to limit search."
  value       = data.aws_ami_ids.this.owners
}

output "executable_users" {
  description = "Users with explicit launch permission on the image."
  value       = data.aws_ami_ids.this.executable_users
}

output "filter" {
  description = "Name/value pairs used to filter the AMI list."
  value       = data.aws_ami_ids.this.filter
}

output "name_regex" {
  description = "Regex string applied to the AMI list returned by AWS."
  value       = data.aws_ami_ids.this.name_regex
}

output "sort_ascending" {
  description = "Whether AMIs are sorted by creation time in ascending order."
  value       = data.aws_ami_ids.this.sort_ascending
}

output "include_deprecated" {
  description = "Whether deprecated AMIs are included in the response."
  value       = data.aws_ami_ids.this.include_deprecated
}