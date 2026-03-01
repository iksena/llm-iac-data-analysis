terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

# Variables with default values
variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "my-eks-cluster"
}

variable "subnet_ids" {
  description = "List of subnet IDs to associate with the EKS Fargate profile. Each subnet is assumed to have the required tag for EKS cluster association."
  type        = list(string)
  default     = ["subnet-0123456789abcdef0", "subnet-0fedcba9876543210"]
}

# IAM role for EKS Fargate pod execution
resource "aws_iam_role" "eks_fargate_pod_execution_role" {
  name               = "eks-fargate-pod-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_fargate_pod_policy_attachment" {
  role       = aws_iam_role.eks_fargate_pod_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}

# EKS Fargate Profile for the kube-system namespace
resource "aws_eks_fargate_profile" "kube_system" {
  cluster_name           = var.cluster_name
  fargate_profile_name   = "kube-system-profile"
  pod_execution_role_arn = aws_iam_role.eks_fargate_pod_execution_role.arn
  subnet_ids             = var.subnet_ids

  selector {
    namespace = "kube-system"
  }
}

# Data sources to read the EKS cluster information and auth token
data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

# Although not used directly in our script, this data source can be useful for authentication checks
data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

# Null resource for patching the 'coredns' deployment in kube-system namespace
resource "null_resource" "patch_coredns" {
  depends_on = [
    aws_eks_fargate_profile.kube_system
  ]

  provisioner "local-exec" {
    # Create a temporary kubeconfig file and use it to patch the coredns deployment.
    command = <<EOT
cat <<EOF > kubeconfig.yaml
apiVersion: v1
kind: Config
clusters:
- cluster:
    server: "${data.aws_eks_cluster.cluster.endpoint}"
    certificate-authority-data: "${data.aws_eks_cluster.cluster.certificate_authority[0].data}"
  name: "${var.cluster_name}"
contexts:
- context:
    cluster: "${var.cluster_name}"
    user: "aws"
  name: "${var.cluster_name}"
current-context: "${var.cluster_name}"
users:
- name: "aws"
  user:
    token: "$(aws eks get-token --cluster-name ${var.cluster_name} --query 'status.token' --output text)"
EOF

# Patch the coredns deployment to update dnsPolicy as an example patch.
kubectl patch deployment coredns -n kube-system --patch '{"spec": {"template": {"spec": {"dnsPolicy": "ClusterFirstWithHostNet"}}}}' --kubeconfig kubeconfig.yaml

rm kubeconfig.yaml
EOT

    interpreter = ["/bin/bash", "-c"]
  }
}