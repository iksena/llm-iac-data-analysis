resource "aws_s3_bucket" "mlflow_artifacts" {
  bucket = var.s3_bucket_name_mlflow
  tags = var.s3_tags
}

resource "aws_s3_bucket_policy" "mlflow_artifacts_policy" {
  bucket = aws_s3_bucket.mlflow_artifacts.id

  policy = <<EOF
{
  "Id": "Policy20240801",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowMLflowEC2Access",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_instance_profile.mlflow_ec2_profile.arn}"
      },
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
    },
    {
      "Sid": "AllowFlaskEC2ReadOnlyAccess",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_instance_profile.flask_ec2_profile.arn}"
      },
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
