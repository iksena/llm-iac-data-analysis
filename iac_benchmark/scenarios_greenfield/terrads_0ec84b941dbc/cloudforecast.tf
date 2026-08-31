resource "aws_iam_role" "cloudforecast" {
  name               = var.role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::656227328603:root"
      },
      "Effect": "Allow",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "${var.external_id}"
        }
      }
    }
  ]
} 
EOF
}

resource "aws_iam_role_policy" "cloudforecast_zw_common_policy" {
  name = "CloudForecast-ZW-Common-Policy"
  role = aws_iam_role.cloudforecast.id
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [ {
    "Action" : [ "cloudwatch:GetMetricStatistics" ],
    "Effect" : "Allow",
    "Resource" : "*"
  }, {
    "Action" : [ "tag:GetResources" ],
    "Effect" : "Allow",
    "Resource" : "*"
  } ]
}
EOF
}

resource "aws_iam_role_policy" "cloudforecast_zw_organization_policy" {
  name = "CloudForecast-ZW-Organization-Policy"
  role = aws_iam_role.cloudforecast.id
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [ {
    "Sid" : "OrganizationListAccess",
    "Action" : [ "organizations:ListAccounts" ],
    "Effect" : "Allow",
    "Resource" : [ "*" ]
  } ]
}
EOF
}

resource "aws_iam_role_policy" "cloudforecast_zw_alb_unused_policy" {
  name = "CloudForecast-ZW-AlbUnusedPolicy"
  role = aws_iam_role.cloudforecast.id
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [ {
    "Effect" : "Allow",
    "Action" : [ "elasticloadbalancing:DescribeLoadBalancers", "elasticloadbalancing:DescribeTags" ],
    "Resource" : "*"
  } ]
}
EOF
}

resource "aws_iam_role_policy" "cloudforecast_zw_ebs_old_snapshots" {
  name = "CloudForecast-ZW-EbsOldSnapshots"
  role = aws_iam_role.cloudforecast.id
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [ {
    "Effect" : "Allow",
    "Action" : [ "ec2:DescribeSnapshots", "ec2:DescribeTags" ],
    "Resource" : "*"
  } ]
}
EOF
}

resource "aws_iam_role_policy" "cloudforecast_zw_ebs_unused_or_unattached" {
  name = "CloudForecast-ZW-EbsUnusedOrUnattached"
  role = aws_iam_role.cloudforecast.id
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [ {
    "Effect" : "Allow",
    "Action" : [ "ec2:DescribeVolumes", "ec2:DescribeTags" ],
    "Resource" : "*"
  } ]
}
EOF
}

resource "aws_iam_role_policy" "cloudforecast_zw_ec2_previous_generation" {
  name = "CloudForecast-ZW-Ec2PreviousGeneration"
  role = aws_iam_role.cloudforecast.id
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [ {
    "Effect" : "Allow",
    "Action" : [ "ec2:DescribeInstances", "ec2:DescribeTags" ],
    "Resource" : "*"
  } ]
}
EOF
}

resource "aws_iam_role_policy" "cloudforecast_zw_ec2_over_provisioned" {
  name = "CloudForecast-ZW-Ec2OverProvisioned"
  role = aws_iam_role.cloudforecast.id
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [ {
    "Effect" : "Allow",
    "Action" : [ "ec2:DescribeInstances", "ec2:DescribeTags" ],
    "Resource" : "*"
  } ]
}
EOF
}

resource "aws_iam_role_policy" "cloudforecast_zw_elb_unused" {
  name = "CloudForecast-ZW-ElbUnused"
  role = aws_iam_role.cloudforecast.id
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [ {
    "Effect" : "Allow",
    "Action" : [ "elasticloadbalancing:DescribeLoadBalancers" ],
    "Resource" : "*"
  } ]
}
EOF
}

resource "aws_iam_role_policy" "cloudforecast_zw_rds_over_provisioned" {
  name = "CloudForecast-ZW-RdsOverProvisioned"
  role = aws_iam_role.cloudforecast.id
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [ {
    "Effect" : "Allow",
    "Action" : [ "rds:DescribeDBInstances" ],
    "Resource" : "*"
  } ]
}
EOF
}

resource "aws_iam_role_policy" "cloudforecast_zw_rds_resize_storeage" {
  name = "CloudForecast-ZW-RdsResizeStoreage"
  role = aws_iam_role.cloudforecast.id
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [ {
    "Effect" : "Allow",
    "Action" : [ "rds:DescribeDBInstances" ],
    "Resource" : "*"
  } ]
}
EOF
}

resource "aws_iam_role_policy" "cloudforecast_zw_rds_unused" {
  name = "CloudForecast-ZW-RdsUnused"
  role = aws_iam_role.cloudforecast.id
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [ {
    "Effect" : "Allow",
    "Action" : [ "rds:DescribeDBInstances" ],
    "Resource" : "*"
  } ]
}
EOF
}

resource "aws_iam_role_policy" "cloudforecast_zw_rds_old_snapshot" {
  name = "CloudForecast-ZW-RdsOldSnapshot"
  role = aws_iam_role.cloudforecast.id
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [ {
    "Effect" : "Allow",
    "Action" : [ "rds:DescribeDBSnapshots" ],
    "Resource" : "*"
  } ]
}
EOF
}

resource "aws_iam_role_policy" "cloudforecast_zw_s3_policy_check" {
  name = "CloudForecast-ZW-S3PolicyCheck"
  role = aws_iam_role.cloudforecast.id
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [ {
    "Effect" : "Allow",
    "Action" : [ "s3:ListAllMyBuckets", "s3:ListBucket", "s3:GetBucketLocation", "s3:GetBucketTagging", "s3:GetLifecycleConfiguration" ],
    "Resource" : "*"
  } ]
}
EOF
}

resource "aws_iam_role_policy" "cloudforecast_zw_cloudwatch_policy_check" {
  name = "CloudForecast-ZW-CloudWatchLogs"
  role = aws_iam_role.cloudforecast.id
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [ {
    "Effect" : "Allow",
    "Action" : [ "logs:DescribeLogGroups" ],
    "Resource" : "*"
  } ]
}
EOF
}

resource "aws_iam_role_policy" "cloudforecast_zw_trusted_advisor" {
  name = "CloudForecast-ZW-TrustedAdvisor"
  role = aws_iam_role.cloudforecast.id
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [ {
    "Effect" : "Allow",
    "Action" : [ "support:DescribeTrustedAdvisorCheckRefreshStatuses", "support:DescribeTrustedAdvisorCheckResult", "support:DescribeTrustedAdvisorChecks", "support:DescribeTrustedAdvisorCheckSummaries", "support:RefreshTrustedAdvisorCheck", "trustedadvisor:Describe*" ],
    "Resource" : "*"
  } ]
}
EOF
}