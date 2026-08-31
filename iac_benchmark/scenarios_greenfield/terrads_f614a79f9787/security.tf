## Security Group attached to EC2 instance ##

resource "aws_security_group" "ec2_sg" {
  name                  = "ec2_sg"
  vpc_id                = aws_vpc.vpc.id

  # no ingress is needed to enble SSM session manager access

  egress {
    from_port           = 443
    to_port             = 443
    protocol            = "tcp"
    cidr_blocks         = [ aws_vpc.vpc.cidr_block ]
  }

  tags                  = local.common_tags
}

## Common Security Group for all VPC Endpoints to AWS services ##

resource "aws_security_group" "svc_vpce_sg" {
  name                  = "svc_vpce_sg"
  vpc_id                = aws_vpc.vpc.id

  ingress {
    cidr_blocks         = [ aws_vpc.vpc.cidr_block ]
    from_port           = 443
    to_port             = 443
    protocol            = "tcp"
  }

  # no egress port access is needed to enable SSM through VPC endpoints

  tags                  = local.common_tags
}

## EC2 Instance Profile and Execution Role ## 

resource "aws_iam_role" "ec2_ssm_exec_role" {
  name_prefix           = "${var.app_shortcode}-ec2-ssm-exec-role-"
  assume_role_policy    = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": "EC2ExecRole"
    }
  ]
}
EOF
  
  depends_on            = [ aws_iam_policy.ec2_ssm_exec_role_permissions ]
  tags                  = local.common_tags
}

# this custom policy is a replacement for AWS managed AmazonSSMManagedInstanceCore policy
# TODO: limit s3 access to specific bucket: arn:aws:s3:::DOC-EXAMPLE-BUCKET/s3-bucket-prefix/*
resource "aws_iam_policy" "ec2_ssm_exec_role_permissions" {
  name_prefix           = "${var.app_shortcode}-ec2-ssm-exec-role-permissions-"
  description           = "Provides EC2 instance access to SSM, S3 and CW Logs services"

  policy                = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "SSMPermissions"
        Action = [
          "ssm:UpdateInstanceInformation",
          "ssm:ListInstanceAssociations", 
          "ssm:DescribeInstanceProperties", 
          "ssm:DescribeDocumentParameters", 
          "ssm:StartSession",
        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Sid = "SSMMessagesPermissions"
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
          "ssm:UpdateInstanceInformation"
        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Sid = "EC2MessagesPermissions"
        Action = [
          "ec2messages:AcknowledgeMessage",
          "ec2messages:DeleteMessage",
          "ec2messages:FailMessage",
          "ec2messages:GetEndpoint",
          "ec2messages:GetMessages",
          "ec2messages:SendReply",
        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Sid = "CWLogsPermissions"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Sid = "KMSPermissions"
        Action = [
          "kms:GenerateDataKey",
        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Sid = "S3Permissions"
        Action = [
          "s3:GetEncryptionConfiguration",
          "s3:PutObject", 
        ]
        Effect = "Allow"
        Resource = "*"
      },
    ]        
  })
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_exec_role_policy" {
  role                  = aws_iam_role.ec2_ssm_exec_role.name
  policy_arn            = aws_iam_policy.ec2_ssm_exec_role_permissions.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name_prefix           = "${var.app_shortcode}-ec2-instance-profile-"
  role                  = aws_iam_role.ec2_ssm_exec_role.name
}

