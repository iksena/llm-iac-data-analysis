output "cluster_versions" {
  description = "A list of Kubernetes version information."
  value       = data.aws_eks_cluster_versions.this.cluster_versions
}

output "cluster_type" {
  description = "Type of cluster that the version belongs to."
  value       = [for version in data.aws_eks_cluster_versions.this.cluster_versions : version.cluster_type]
}

output "cluster_version" {
  description = "Kubernetes version supported by EKS."
  value       = [for version in data.aws_eks_cluster_versions.this.cluster_versions : version.cluster_version]
}

output "default_platform_version" {
  description = "Default eks platform version for the cluster version."
  value       = [for version in data.aws_eks_cluster_versions.this.cluster_versions : version.default_platform_version]
}

output "default_version" {
  description = "Default Kubernetes version for the cluster version."
  value       = [for version in data.aws_eks_cluster_versions.this.cluster_versions : version.default_version]
}

output "end_of_extended_support_date" {
  description = "End of extended support date for the cluster version."
  value       = [for version in data.aws_eks_cluster_versions.this.cluster_versions : version.end_of_extended_support_date]
}

output "end_of_standard_support_date" {
  description = "End of standard support date for the cluster version."
  value       = [for version in data.aws_eks_cluster_versions.this.cluster_versions : version.end_of_standard_support_date]
}

output "kubernetes_patch_version" {
  description = "Kubernetes patch version for the cluster version."
  value       = [for version in data.aws_eks_cluster_versions.this.cluster_versions : version.kubernetes_patch_version]
}

output "release_date" {
  description = "Release date of the cluster version."
  value       = [for version in data.aws_eks_cluster_versions.this.cluster_versions : version.release_date]
}

output "version_status" {
  description = "Status of the EKS cluster version."
  value       = [for version in data.aws_eks_cluster_versions.this.cluster_versions : version.version_status]
}