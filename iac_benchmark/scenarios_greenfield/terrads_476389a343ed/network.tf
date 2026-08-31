# https://www.terraform.io/docs/providers/aws/d/availability_zones.html
data "aws_availability_zones" "available" {
  state = "available"
}

# ================================================================================
#  VPC
# ================================================================================

# Guide:
# https://github.com/kubernetes/kops/blob/master/docs/run_in_existing_vpc.md

# https://www.terraform.io/docs/providers/aws/r/vpc.html
resource "aws_vpc" "main" {
  cidr_block = lookup(var.vpc_cidrs, var.region)

  tags = merge(local.common_tags, local.region_tag, {
    "Name" = local.name
  })
}

# ================================================================================
#  Subnets
# ================================================================================

# https://www.terraform.io/docs/providers/aws/r/subnet.html
resource "aws_subnet" "private" {
  count = var.create_subnets ? local.az_len : 0

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(local.common_tags, local.region_tag, {
    "Name" = format("%s-private-%d", local.name, 1 + count.index)
  })
}

# https://www.terraform.io/docs/providers/aws/r/subnet.html
resource "aws_subnet" "public" {
  count = var.create_subnets ? local.az_len : 0

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 128 + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(local.common_tags, local.region_tag, {
    "Name" = format("%s-public-%d", local.name, 1 + count.index)
  })
}

# ================================================================================
#  Elastic IPs
# ================================================================================

# https://www.terraform.io/docs/providers/aws/r/eip.html
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html
resource "aws_eip" "nat" {
  count = var.create_subnets ? local.az_len : 0

  vpc = true

  tags = merge(local.common_tags, local.region_tag, {
    "Name" = format("%s-%d", local.name, 1 + count.index)
  })
}

# ================================================================================
#  Gateways
# ================================================================================

# https://www.terraform.io/docs/providers/aws/r/nat_gateway.html
# https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html
resource "aws_nat_gateway" "main" {
  count = var.create_subnets ? local.az_len : 0

  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id = element(aws_subnet.public.*.id, count.index)

  tags = merge(local.common_tags, local.region_tag, {
    "Name" = format("%s-%d", local.name, 1 + count.index)
  })
}

# https://www.terraform.io/docs/providers/aws/r/internet_gateway.html
# https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, local.region_tag, {
    "Name" = local.name
  })
}

# ================================================================================
#  Route Tables
# ================================================================================

# https://www.terraform.io/docs/providers/aws/r/route_table.html
# https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html
resource "aws_route_table" "private" {
  count = var.create_subnets ? local.az_len : 0

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.main.*.id, count.index)
  }

  tags = merge(local.common_tags, local.region_tag, {
    "Name" = format("%s-private-%d", local.name, 1 + count.index)
  })
}

# https://www.terraform.io/docs/providers/aws/r/route_table_association.html
resource "aws_route_table_association" "private" {
  count = var.create_subnets ? local.az_len : 0

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

# https://www.terraform.io/docs/providers/aws/r/route_table.html
# https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html
resource "aws_route_table" "public" {
  count = var.create_subnets ? 1 : 0

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(local.common_tags, local.region_tag, {
    "Name" = format("%s-public", local.name)
  })
}

# https://www.terraform.io/docs/providers/aws/r/route_table_association.html
resource "aws_route_table_association" "public" {
  count = var.create_subnets ? local.az_len : 0

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public[0].id
}

# ================================================================================
#  IAM
# ================================================================================

# https://www.terraform.io/docs/providers/aws/r/iam_instance_profile.html
# https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html
resource "aws_iam_instance_profile" "vpc" {
  count = var.enable_vpc_logs ? 1 : 0

  name = "${local.name}-vpc"
  role = aws_iam_role.vpc[0].name
}

# https://www.terraform.io/docs/providers/aws/r/iam_role.html
# https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
resource "aws_iam_role" "vpc" {
  count = var.enable_vpc_logs ? 1 : 0

  name = "${local.name}-vpc"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = merge(local.common_tags, {
    "Name" = format("%s-vpc", local.name)
  })
}

# https://www.terraform.io/docs/providers/aws/r/iam_role_policy.html
resource "aws_iam_role_policy" "vpc" {
  count = var.enable_vpc_logs ? 1 : 0

  name = "${local.name}-vpc"
  role = aws_iam_role.vpc[0].id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "${aws_cloudwatch_log_group.vpc[0].arn}"
    }
  ]
}
EOF
}

# ================================================================================
#  CloudWatch
# ================================================================================

# https://www.terraform.io/docs/providers/aws/r/cloudwatch_log_group.html
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CloudWatchLogsConcepts.html
resource "aws_cloudwatch_log_group" "vpc" {
  count = var.enable_vpc_logs ? 1 : 0

  name              = "${local.name}-vpc"
  retention_in_days = 90

  tags = merge(local.common_tags, local.region_tag, {
    "Name" = format("%s-vpc", local.name)
  })
}

# https://www.terraform.io/docs/providers/aws/r/flow_log.html
# https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html
resource "aws_flow_log" "vpc" {
  count = var.enable_vpc_logs ? 1 : 0

  iam_role_arn         = aws_iam_role.vpc[0].arn
  log_destination      = aws_cloudwatch_log_group.vpc[0].arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.main.id
}
