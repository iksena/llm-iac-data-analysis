def test_template(template: Template):
    # Auto Scaling Group
    template.has_resource_properties(
        "AWS::AutoScaling::AutoScalingGroup",
        {
            "AvailabilityZones": Match.any_value(),
            "DesiredCapacity": Match.any_value(),
            "MaxSize": 2,
            "MinSize": 1,
            "VPCZoneIdentifier": Match.any_value(),
        },
    )

    # SQS Queue
    template.has_resource_properties(
        "AWS::SQS::Queue",
        {
            "VisibilityTimeout": Match.any_value(),
            "MessageRetentionPeriod": Match.any_value(),
        },
    )

    # S3 Bucket
    template.has_resource_properties(
        "AWS::S3::Bucket",
        {
            "AccessControl": Match.any_value(),
            "VersioningConfiguration": Match.any_value(),
        },
    )

    # CloudWatch Alarms for scaling
    template.has_resource_properties(
        "AWS::CloudWatch::Alarm",
        {
            "Namespace": "AWS/SQS",
            "MetricName": "ApproximateNumberOfMessagesVisible",
            "ComparisonOperator": "GreaterThanThreshold",
            "Statistic": "Average",
        },
    )

    template.has_resource_properties(
        "AWS::CloudWatch::Alarm",
        {
            "Namespace": "AWS/SQS",
            "MetricName": "ApproximateNumberOfMessagesVisible",
            "ComparisonOperator": "LessThanThreshold",
            "Statistic": "Average",
        },
    )

    # Load Test Instance
    template.has_resource_properties(
        "AWS::EC2::Instance",
        {
            "UserData": Match.any_value(),
            "IamInstanceProfile": Match.any_value(),
        },
    )

    # IAM Role for EC2 instances
    template.has_resource_properties(
        "AWS::IAM::Role",
        {
            "AssumeRolePolicyDocument": {
                "Statement": [
                    {
                        "Effect": "Allow",
                        "Principal": {"Service": "ec2.amazonaws.com"},
                        "Action": "sts:AssumeRole",
                    }
                ]
            },
            "ManagedPolicyArns": Match.array_with(
                Match.string_like_regexp("arn:aws:iam::aws:policy/.*")
            ),
        },
    )

    # Scaling Policies
    template.has_resource_properties(
        "AWS::AutoScaling::ScalingPolicy",
        {
            "AdjustmentType": "ChangeInCapacity",
            "ScalingAdjustment": 1,
        },
    )

    template.has_resource_properties(
        "AWS::AutoScaling::ScalingPolicy",
        {
            "AdjustmentType": "ChangeInCapacity",
            "ScalingAdjustment": -1,
        },
    )

    # Resource counts
    template.resource_count_is("AWS::AutoScaling::AutoScalingGroup", 1)
    template.resource_count_is("AWS::SQS::Queue", 1)
    template.resource_count_is("AWS::S3::Bucket", 1)
    template.resource_count_is("AWS::EC2::Instance", 2)  # 1 worker ASG + 1 load test
    template.resource_count_is("AWS::IAM::Role", 1)
    template.resource_count_is("AWS::CloudWatch::Alarm", 2)
    template.resource_count_is("AWS::AutoScaling::ScalingPolicy", 2)