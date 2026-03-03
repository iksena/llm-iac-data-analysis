The Terraform program will create an AWS EKS node group associated with an existing EKS cluster named "example". The node group will be configured with specific scaling parameters and update settings. It will also include the necessary IAM roles and policies to ensure proper permissions for lifecycle events of EC2 instances and network interfaces. The node group will be deployed in specified subnets, and the IAM role will have the necessary policies attached for EKS worker nodes, EKS CNI, and EC2 container registry read-only access.

<iac_template>

```hcl
provider "aws" {
  region = "us-west-2"
}

data "aws_eks_cluster" "example" {
  name = "example"
}

data "aws_eks_cluster_auth" "example" {
  name = data.aws_eks_cluster.example.name
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_eks_cluster.example.vpc_id
}

resource "aws_iam_role" "eks_node_group_role" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_eks_node_group" "example" {
  cluster_name    = data.aws_eks_cluster.example.name
  node_group_name = "example"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = data.aws_subnet_ids.all.ids

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
}
```

</iac_template>