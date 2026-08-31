#
# Outputs
#

locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH


apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.node_iam.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH

  kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.cluster.endpoint}
    certificate-authority-data: ${aws_eks_cluster.cluster.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.customer_name}-${var.cluster_name}"
KUBECONFIG
}

output "cluster_id" {
  description = "Cluster ID"
  value = "${aws_eks_cluster.cluster.id}"
}

output "config_map_aws_auth" {
  description = "Configmap for AWS Auth"
  value = local.config_map_aws_auth
}

output "iam_role_node" {
  description = "IAM role for node"
  value = aws_iam_role.node_iam.id
}

output "kubeconfig" {
  description = "Kubeconfig"
  value = local.kubeconfig
}

output "oidc_provider" {
  description = "OIDC Provider"
  value = aws_iam_openid_connect_provider.cluster.id
}

output "public_subnets" {
  description = "List of IDs of subnets with this cluster"
  value       = aws_subnet.public_subnet.id
}

output "private_subnets" {
  description = "List of IDs of subnets with this cluster"
  value       = aws_subnet.private_subnet[*].id
}

output "vpc_id" {
  description = "VPC ID"
  value       = "${aws_vpc.vpc_id.id}"
}

output "vpc_cidr" {
  description = "VPC CIDR Block"
  value       = "${aws_vpc.vpc_id.cidr_block}"
}
