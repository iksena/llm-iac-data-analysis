data "aws_iam_policy_document" "role_assume_fis" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["fis.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:fis:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:experiment/*"]
    }
  }
}

resource "aws_iam_role" "fis" {
  name               = local.name
  assume_role_policy = data.aws_iam_policy_document.role_assume_fis.json
}

data "aws_iam_policy_document" "fis_fault_injection" {
  statement {
    effect = "Allow"
    actions = [
      "fis:InjectApiInternalError",
      "fis:InjectApiThrottleError",
      "fis:InjectApiUnavailableError",
    ]
    resources = ["arn:*:fis:*:*:experiment/*"]
  }
}


resource "aws_iam_role_policy" "fis_fault_injection" {
  policy = data.aws_iam_policy_document.fis_fault_injection.json
  role   = aws_iam_role.fis.id
}

data "aws_iam_policy_document" "fis_logs" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogDelivery" # TODO: more fine-grained?
    ]
    resources = ["*"]
  }
}


resource "aws_iam_role_policy" "fis_logs" {
  policy = data.aws_iam_policy_document.fis_logs.json
  role   = aws_iam_role.fis.id
}

# managed policy - TODO - use customer defined?
resource "aws_iam_role_policy_attachment" "fis_ec2_managed" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSFaultInjectionSimulatorEC2Access"
  role       = aws_iam_role.fis.name
}

resource "aws_iam_role_policy_attachment" "fis_managed_network" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSFaultInjectionSimulatorNetworkAccess"
  role       = aws_iam_role.fis.name
}

data "aws_iam_policy_document" "fis_ebs" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeVolumes",
      "ec2:PauseVolumeIO",
    ]
    resources = ["*"]
  }

}


resource "aws_iam_role_policy" "fis_ebs" {
  policy = data.aws_iam_policy_document.fis_ebs.json
  role   = aws_iam_role.fis.id
}