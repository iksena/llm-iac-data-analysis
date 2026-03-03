I'll help you create a Terraform configuration for an AWS EKS node group with the specified requirements. This configuration will:

1. Create necessary IAM roles and policy attachments for EKS node group
2. Create an EKS node group with specified scaling parameters
3. Include all required dependencies and permissions
4. Configure update settings for node management

The configuration assumes an existing EKS cluster and VPC with subnets. Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Create IAM role for EKS Node Group
resource "aws_iam_role" "eks_node_group_role" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

# Attach required policies to the IAM role
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role.name
}

# Create EKS Node Group
resource "aws_eks_node_group" "example" {
  cluster_name    = "example"
  node_group_name = "example"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  
  # Specify subnets where nodes will be created
  subnet_ids = [
    "subnet-12345678", # Replace with actual subnet IDs
    "subnet-87654321"
  ]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Instance types for the node group
  instance_types = ["t3.medium"]

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ecr_read_only,
  ]

  tags = {
    Name = "example-eks-node-group"
  }
}
</iac_template>

This Terraform configuration creates:

1. An IAM role for the EKS node group with the necessary trust relationship
2. Three IAM role policy attachments for:
   - AmazonEKSWorkerNodePolicy
   - AmazonEKS_CNI_Policy
   - AmazonEC2ContainerRegistryReadOnly
3. An EKS node group with:
   - Specified scaling configuration (desired: 1, max: 2, min: 1)
   - Update configuration with max_unavailable set to 1
   - T3.medium instance type
   - Proper dependencies on IAM role policies

Note: You'll need to replace the subnet IDs with actual subnet IDs from your VPC. Also, ensure that the EKS cluster named "example" exists before applying this configuration.

The configuration uses the AWS provider and is set to the us-west-2 region, but you can modify this according to your needs. All necessary permissions and dependencies are properly configured to ensure smooth operation of the EKS node group.