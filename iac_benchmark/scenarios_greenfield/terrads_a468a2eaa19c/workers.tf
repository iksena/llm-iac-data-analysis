#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#

# IAM role and policy to allow the worker nodes to manage or retrieve data from other AWS services. 
# It is used by Kubernetes to allow worker nodes to join the cluster.
resource "aws_iam_role" "node_iam" {
  name = "eks-node-iam-${var.customer_name}-${var.cluster_name}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_iam.name
}

resource "aws_iam_role_policy_attachment" "node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_iam.name
}

resource "aws_iam_role_policy_attachment" "node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_iam.name
}

# EKS has implemented CNI in a bit stupid way and has limited number of pods per instance to 
# (max number of nw interface in instance X no of ips per ENI ).  As of now we run all our app 
# in a separate pod and I was trying to pack our entire app in t3.medium instance and then use auto-scaling, when required. 
# That can be used to launch a poc prophecy cluster or a dev prophecy cluster. And the compute available in t3.medium should 
# have been suitable for that. But could not do that because of above limitation. Different instance type in AWS support different 
# no of instances and different no of ips. At some point of time, we will figure out the best instance type for us for a poc/dev environment with minimal cost.
# Also at some point of time, we need to restructure our operator design and pack multiple apps in single pod. Probably whenever we get down to exercise 
# of minimising the cost of cloud based prophecy cluster.

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "node-group-${var.customer_name}-${var.cluster_name}"
  node_role_arn   = aws_iam_role.node_iam.arn
  subnet_ids      = aws_subnet.private_subnet[*].id
  instance_types  = ["t3.2xlarge"]

  scaling_config {
    desired_size = var.autoscaling_options.desired_size
    max_size     = var.autoscaling_options.max_size
    min_size     = var.autoscaling_options.min_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-AmazonEC2ContainerRegistryReadOnly,
  ]
}
