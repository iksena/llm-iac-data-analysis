output "prefix" {
  description = "Name prefix of the runtime version"
  value       = data.aws_synthetics_runtime_version.this.prefix
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_synthetics_runtime_version.this.region
}

output "latest" {
  description = "Whether the latest version of the runtime was fetched"
  value       = data.aws_synthetics_runtime_version.this.latest
}

output "version" {
  description = "Version of the runtime that was fetched"
  value       = data.aws_synthetics_runtime_version.this.version
}

output "deprecation_date" {
  description = "Date of deprecation if the runtime version is deprecated"
  value       = data.aws_synthetics_runtime_version.this.deprecation_date
}

output "description" {
  description = "Description of the runtime version, created by Amazon"
  value       = data.aws_synthetics_runtime_version.this.description
}

output "id" {
  description = "Name of the runtime version"
  value       = data.aws_synthetics_runtime_version.this.id
}

output "release_date" {
  description = "Date that the runtime version was released"
  value       = data.aws_synthetics_runtime_version.this.release_date
}

output "version_name" {
  description = "Name of the runtime version"
  value       = data.aws_synthetics_runtime_version.this.version_name
}