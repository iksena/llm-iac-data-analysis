output "id" {
  description = "Name of the add-on."
  value       = data.aws_eks_addon_version.this.id
}

output "version" {
  description = "Version of the EKS add-on."
  value       = data.aws_eks_addon_version.this.version
}