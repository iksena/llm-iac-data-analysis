resource "aws_eks_cluster" "eks" {
  name     = "eks"
  role_arn = aws_iam_role.eks-iam-role.arn

  vpc_config {
    endpoint_public_access = true
    subnet_ids = [
      aws_subnet.my_subnet[0].id,
      aws_subnet.my_subnet[1].id
    ]
    security_group_ids = [aws_security_group.sg.id]
  }

  kubernetes_network_config {
    service_ipv4_cidr = "10.2.0.0/24"
    ip_family         = "ipv4"
  }

  depends_on = [
    aws_iam_role.eks-iam-role
  ]
}

resource "aws_eks_node_group" "worker-node-group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "workernodes"
  node_role_arn   = aws_iam_role.worker-nodes-iam-role.arn
  subnet_ids = [
    aws_subnet.my_subnet[0].id,
    aws_subnet.my_subnet[1].id
  ]

  capacity_type  = "SPOT"
  instance_types = ["t3.small"]
  disk_size      = "20"

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  remote_access {
    ec2_ssh_key = aws_key_pair.key_pair.key_name
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly-Node,
  ]
}

#-------------------------------------------------------------------------------#
#               AWS Cluster Storage Interface                                   #
#-------------------------------------------------------------------------------#

resource "aws_eks_addon" "csi_driver" {
  cluster_name             = aws_eks_cluster.eks.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.29.1-eksbuild.1"
  service_account_role_arn = aws_iam_role.eks_ebs_csi_driver.arn
}

#-------------------------------------------------------------------------------#
#               AWS EBS Volume 4GB                                              #
#-------------------------------------------------------------------------------#

resource "aws_ebs_volume" "persistent_volume" {
  availability_zone = "eu-west-2a"
  size              = 8

  tags = {
    Name = "persistent_volume"
  }
}