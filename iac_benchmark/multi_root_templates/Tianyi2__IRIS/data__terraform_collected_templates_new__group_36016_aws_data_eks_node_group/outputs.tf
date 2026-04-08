output "id" {
  description = "EKS Cluster name and EKS Node Group name separated by a colon (:)."
  value       = data.aws_eks_node_group.this.id
}

output "ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group."
  value       = data.aws_eks_node_group.this.ami_type
}

output "arn" {
  description = "ARN of the EKS Node Group."
  value       = data.aws_eks_node_group.this.arn
}

output "capacity_type" {
  description = "Type of capacity associated with the EKS Node Group. Valid values: ON_DEMAND, SPOT."
  value       = data.aws_eks_node_group.this.capacity_type
}

output "disk_size" {
  description = "Disk size in GiB for worker nodes."
  value       = data.aws_eks_node_group.this.disk_size
}

output "instance_types" {
  description = "Set of instance types associated with the EKS Node Group."
  value       = data.aws_eks_node_group.this.instance_types
}

output "labels" {
  description = "Key-value map of Kubernetes labels. Only labels that are applied with the EKS API are managed by this argument. Other Kubernetes labels applied to the EKS Node Group will not be managed."
  value       = data.aws_eks_node_group.this.labels
}

output "launch_template" {
  description = "Nested attribute containing information about the launch template used to create the EKS Node Group."
  value       = data.aws_eks_node_group.this.launch_template
}

output "node_role_arn" {
  description = "ARN of the IAM Role that provides permissions for the EKS Node Group."
  value       = data.aws_eks_node_group.this.node_role_arn
}

output "release_version" {
  description = "AMI version of the EKS Node Group."
  value       = data.aws_eks_node_group.this.release_version
}

output "remote_access" {
  description = "Configuration block with remote access settings."
  value       = data.aws_eks_node_group.this.remote_access
}

output "resources" {
  description = "List of objects containing information about underlying resources."
  value       = data.aws_eks_node_group.this.resources
}

output "scaling_config" {
  description = "Configuration block with scaling settings."
  value       = data.aws_eks_node_group.this.scaling_config
}

output "status" {
  description = "Status of the EKS Node Group."
  value       = data.aws_eks_node_group.this.status
}

output "subnet_ids" {
  description = "Identifiers of EC2 Subnets to associate with the EKS Node Group."
  value       = data.aws_eks_node_group.this.subnet_ids
}

output "taints" {
  description = "List of objects containing information about taints applied to the nodes in the EKS Node Group."
  value       = data.aws_eks_node_group.this.taints
}

output "tags" {
  description = "Key-value map of resource tags."
  value       = data.aws_eks_node_group.this.tags
}

output "version" {
  description = "Kubernetes version."
  value       = data.aws_eks_node_group.this.version
}