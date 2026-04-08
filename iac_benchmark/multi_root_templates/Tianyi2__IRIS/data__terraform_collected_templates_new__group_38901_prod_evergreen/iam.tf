## ---------------------------------------------------------------------------------------------------------------------
## AWS EC2 Instance Role for the NAT Gateway
## ---------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "nat_service_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "nat_instance_bind_network_interfaces" {
  statement {
    actions = [
      "ec2:AttachNetworkInterface",
      "ec2:ModifyNetworkInterfaceAttribute",
    ]
    // TODO: Scope this down to the ENI
    resources = ["*"]
    effect    = "Allow"
  }
}

data "aws_iam_policy_document" "nat_instance_associate_eip" {
  statement {
    actions = [
      "ec2:AssociateAddress",
      "ec2:DisassociateAddress",
    ]
    // TODO: Scope this down to the NAT Gateway instance
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_role" "nat_service_role" {
  name               = "EvergreenProdNATServiceRole"
  assume_role_policy = data.aws_iam_policy_document.nat_service_role.json

  inline_policy {
    name   = "EvergreenProdNATInstanceBindNetworkInterfaces"
    policy = data.aws_iam_policy_document.nat_instance_bind_network_interfaces.json
  }

  inline_policy {
    name   = "EvergreenProdNATInstanceAssociateEIP"
    policy = data.aws_iam_policy_document.nat_instance_associate_eip.json
  }
}

resource "aws_iam_instance_profile" "nat_service_role" {
  name = "EvergreenProdNATServiceRole"
  role = aws_iam_role.nat_service_role.name
}

resource "aws_iam_role_policy_attachment" "nat_ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.nat_service_role.name
}

## ---------------------------------------------------------------------------------------------------------------------
## AWS EC2 Instance Role for the Container Service Nodes
## ---------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "evergreen_node_service_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "evergreen_node_service_role" {
  name               = "EvergreenProdNodeServiceRole"
  assume_role_policy = data.aws_iam_policy_document.evergreen_node_service_role.json
}

resource "aws_iam_instance_profile" "evergreen_node_service_role" {
  name = "EvergreenProdNodeServiceRole"
  role = aws_iam_role.evergreen_node_service_role.name
}

resource "aws_iam_role_policy_attachment" "evergreen_node_ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.evergreen_node_service_role.name
}

resource "aws_iam_role_policy_attachment" "evergreen_node_ecs" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  role       = aws_iam_role.evergreen_node_service_role.name
}
