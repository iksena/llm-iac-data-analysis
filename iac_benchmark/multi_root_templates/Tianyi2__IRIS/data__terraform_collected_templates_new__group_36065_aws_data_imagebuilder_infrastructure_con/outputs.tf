output "arns" {
  description = "Set of ARNs of the matched Image Builder Infrastructure Configurations."
  value       = data.aws_imagebuilder_infrastructure_configurations.this.arns
}

output "names" {
  description = "Set of names of the matched Image Builder Infrastructure Configurations."
  value       = data.aws_imagebuilder_infrastructure_configurations.this.names
}