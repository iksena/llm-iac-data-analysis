resource "aws_s3_bucket" "elb_log" {
    bucket = "${var.app_name}-elb-log-${data.aws_caller_identity.current.account_id}"
    acl = "private"

    # lifecycle_rule {
    #     id = "log"
    #     prefix = "log/"
    #     enabled = true

    #     transition {
    #         days = 30
    #         storage_class = "STANDARD_IA"
    #     }
    #     transition {
    #         days = 60
    #         storage_class = "GLACIER"
    #     }
    #     expiration {
    #         days = 90
    #     }
    # }
    # lifecycle_rule {
    #     id = "log"
    #     prefix = "tmp/"
    #     enabled = true

    #     expiration {
    #         date = "2016-01-12"
    #     }
    # }
    policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AddPerm",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::${var.app_name}-elb-log/*"
    }
  ]
}
POLICY

    tags = {
        Name = "${var.app_name}-elb-log"
    }
}