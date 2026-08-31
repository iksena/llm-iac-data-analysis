# Allow list/read of any bucket
# Allow full access only to result bucket
resource "aws_iam_policy" "ecs_s3_access" {
  name   = "ecs_s3_policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "S3:List*"
            ],
            "Resource": ["*"]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "${aws_s3_bucket.results.arn}",
                "${aws_s3_bucket.results.arn}/*"
            ]
        }
    ]
}
EOF
}


resource "aws_iam_role" "ecs_instance" {

  name = "${local.common_tags.Name}-ecs-instance-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
            "Service": "ec2.amazonaws.com"
        }
    }
    ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "ecs_for_ec2" {
  role       = aws_iam_role.ecs_instance.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}


resource "aws_iam_role_policy_attachment" "ecs_s3_access" {
  role       = aws_iam_role.ecs_instance.name
  policy_arn = aws_iam_policy.ecs_s3_access.arn
}


resource "aws_iam_instance_profile" "ecs_instance" {
  name = "${local.common_tags.Name}-ecs-instance-role"
  role = aws_iam_role.ecs_instance.name
}


#####################################################################################################


resource "aws_iam_role" "aws_batch_service" {
  name = "${local.common_tags.Name}-batch-service-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Effect": "Allow",
            "Principal": {
                "Service": "batch.amazonaws.com"
            }
        }
    ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "batch_service" {
  role       = aws_iam_role.aws_batch_service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}