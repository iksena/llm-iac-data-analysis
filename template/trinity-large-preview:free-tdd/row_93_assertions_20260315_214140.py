def test_template(template: Template):
    # EC2 Instance with latest Amazon Linux AMI
    template.has_resource_properties(
        "AWS::EC2::Instance",
        {
            "ImageId": Match.string_like_regexp("ami-.*"),
            "IamInstanceProfile": Match.any_value(),
            "Tags": Match.array_with(
                Match.object_like({"Key": "Name", "Value": Match.any_value()})
            )
        }
    )

    # IAM Role for SSM access
    template.has_resource_properties(
        "AWS::IAM::Role",
        {
            "AssumeRolePolicyDocument": Match.object_like({
                "Statement": Match.array_with(
                    Match.object_like({
                        "Principal": Match.object_like({
                            "Service": Match.array_with("ec2.amazonaws.com")
                        }),
                        "Action": Match.array_with("sts:AssumeRole")
                    })
                )
            }),
            "ManagedPolicyArns": Match.array_with(
                Match.string_like_regexp("arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore")
            )
        }
    )

    # SSM Association for Nginx installation
    template.has_resource_properties(
        "AWS::SSM::Association",
        {
            "Name": Match.string_like_regexp("AWS-ApplyPatchBaseline"),
            "Targets": Match.array_with(
                Match.object_like({
                    "Key": "tag:Name",
                    "Values": Match.array_with(Match.any_value())
                })
            ),
            "DocumentVersion": Match.any_value(),
            "Parameters": Match.any_value()
        }
    )

    # S3 Bucket for logs
    template.has_resource_properties(
        "AWS::S3::Bucket",
        {
            "BucketName": Match.any_value(),
            "AccessControl": Match.any_value(),
            "VersioningConfiguration": Match.object_like({
                "Status": "Enabled"
            })
        }
    )

    # IAM Policy for S3 access
    template.has_resource_properties(
        "AWS::IAM::Policy",
        {
            "PolicyDocument": Match.object_like({
                "Statement": Match.array_with(
                    Match.object_like({
                        "Effect": "Allow",
                        "Action": Match.array_with(
                            "s3:Get*",
                            "s3:List*",
                            "s3:Put*",
                            "s3:Delete*"
                        ),
                        "Resource": Match.array_with(
                            Match.string_like_regexp("arn:aws:s3:::"),
                            Match.string_like_regexp("arn:aws:s3:::./*")
                        )
                    })
                )
            })
        }
    )

    # CloudWatch monitoring integration
    template.has_resource_properties(
        "AWS::CloudWatch::Alarm",
        {
            "ComparisonOperator": Match.any_value(),
            "EvaluationPeriods": Match.any_value(),
            "MetricName": Match.any_value(),
            "Namespace": Match.any_value(),
            "Period": Match.any_value(),
            "Statistic": Match.any_value(),
            "Threshold": Match.any_value()
        }
    )