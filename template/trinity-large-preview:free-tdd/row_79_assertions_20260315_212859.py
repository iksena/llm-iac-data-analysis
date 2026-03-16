def test_template(template: Template):
    # S3 Access Policy
    template.has_resource_properties("AWS::IAM::ManagedPolicy", {
        "PolicyDocument": {
            "Statement": Match.array_with({
                "Effect": "Allow",
                "Action": Match.array_with(
                    "s3:PutObject",
                    "s3:GetObject",
                    "s3:DeleteObject",
                    "s3:ListBucket",
                    "s3:GetBucketLocation"
                ),
                "Resource": Match.array_with(
                    "arn:aws:s3:::ios-apps.sagebridge.org",
                    "arn:aws:s3:::ios-apps.sagebridge.org/*"
                )
            })
        }
    })

    # DynamoDB Protection Policy
    template.has_resource_properties("AWS::IAM::ManagedPolicy", {
        "PolicyDocument": {
            "Statement": Match.array_with({
                "Effect": "Deny",
                "Action": Match.array_with(
                    "dynamodb:DeleteTable",
                    "dynamodb:UpdateTable"
                ),
                "Resource": Match.any_value
            })
        }
    })

    # RDS Protection Policy
    template.has_resource_properties("AWS::IAM::ManagedPolicy", {
        "PolicyDocument": {
            "Statement": Match.array_with({
                "Effect": "Deny",
                "Action": Match.array_with(
                    "rds:DeleteDBInstance",
                    "rds:DeleteDBCluster"
                ),
                "Resource": Match.any_value
            })
        }
    })

    # Verify exactly three managed policies exist
    template.resource_count_is("AWS::IAM::ManagedPolicy", 3)