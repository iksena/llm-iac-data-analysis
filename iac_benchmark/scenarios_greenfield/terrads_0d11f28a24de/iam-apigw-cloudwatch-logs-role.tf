resource "aws_api_gateway_account" "apigw_logging_us_east_1" {
  cloudwatch_role_arn = aws_iam_role.apigw_logging.arn
  provider            = aws.us-east-1
}
/*
resource "aws_api_gateway_account" "apigw_logging_us_east_2" {
  cloudwatch_role_arn = aws_iam_role.apigw_logging.arn
  provider            = aws.us-east-2
}
*/
/*
resource "aws_api_gateway_account" "apigw_logging_us_west_1" {
  cloudwatch_role_arn = aws_iam_role.apigw_logging.arn
  provider            = aws.us-west-1
}
*/
/*
resource "aws_api_gateway_account" "apigw_logging_us_west_2" {
  cloudwatch_role_arn = aws_iam_role.apigw_logging.arn
  provider            = aws.us-west-2
}
*/
resource "aws_iam_role" "apigw_logging" {
  name               = "${var.name_prefix}-apigw-cloudwatch-logging-role${local.name_suffix}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags = merge(
    local.common_tags
  )
}

data "aws_iam_policy" "amazon_api_gateway_push_to_cloud_watch_logs" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_iam_role_policy_attachment" "apigw_logging" {
  role       = aws_iam_role.apigw_logging.id
  policy_arn = data.aws_iam_policy.amazon_api_gateway_push_to_cloud_watch_logs.arn
}