output "id" {
  description = "Name of the AWS region from which runtime versions are fetched."
  value       = data.aws_synthetics_runtime_versions.this.id
}

output "runtime_versions" {
  description = "List of runtime versions."
  value       = data.aws_synthetics_runtime_versions.this.runtime_versions
}

output "runtime_versions_deprecation_date" {
  description = "Date of deprecation if the runtime version is deprecated for each runtime version."
  value       = [for rv in data.aws_synthetics_runtime_versions.this.runtime_versions : rv.deprecation_date]
}

output "runtime_versions_description" {
  description = "Description of the runtime version, created by Amazon for each runtime version."
  value       = [for rv in data.aws_synthetics_runtime_versions.this.runtime_versions : rv.description]
}

output "runtime_versions_release_date" {
  description = "Date that the runtime version was released for each runtime version."
  value       = [for rv in data.aws_synthetics_runtime_versions.this.runtime_versions : rv.release_date]
}

output "runtime_versions_version_name" {
  description = "Name of the runtime version for each runtime version."
  value       = [for rv in data.aws_synthetics_runtime_versions.this.runtime_versions : rv.version_name]
}