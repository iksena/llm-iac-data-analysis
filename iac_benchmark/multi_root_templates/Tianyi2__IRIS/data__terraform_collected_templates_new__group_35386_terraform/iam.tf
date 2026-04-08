# mlflow_ec2
resource "aws_iam_role" "mlflow_ec2_role" {
  name = "mlflow_ec2_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "mlflow_ec2_s3_policy" {
  name = "mlflow_ec2_s3_policy"
  role = aws_iam_role.mlflow_ec2_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:DeleteObject"
      ],
      "Resource": [
        "${aws_s3_bucket.mlflow_artifacts.arn}",
        "${aws_s3_bucket.mlflow_artifacts.arn}/*"
      ]
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "mlflow_ec2_profile" {
  name = "mlflow_ec2_profile"
  role = aws_iam_role.mlflow_ec2_role.name
}

# flask_ec2
resource "aws_iam_role" "flask_ec2_role" {
  name = "flask_ec2_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "flask_ec2_s3_policy" {
  name = "flask_ec2_s3_policy"
  role = aws_iam_role.flask_ec2_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "${aws_s3_bucket.mlflow_artifacts.arn}",
        "${aws_s3_bucket.mlflow_artifacts.arn}/*"
      ]
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "flask_ec2_profile" {
  name = "flask_ec2_profile"
  role = aws_iam_role.flask_ec2_role.name
}
