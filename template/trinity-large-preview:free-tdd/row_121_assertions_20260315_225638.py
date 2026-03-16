def test_template(template: Template):
    # Assert SSM Document exists
    template.has_resource_properties(
        "AWS::SSM::Document",
        {
            "DocumentType": "Automation",
            "Content": Match.object_like({
                "schemaVersion": "0.3",
                "description": Match.any_value(),
                "mainSteps": Match.any_value()
            })
        }
    )

    # Assert EC2 instances with SSM role
    template.has_resource_properties(
        "AWS::EC2::Instance",
        {
            "IamInstanceProfile": Match.any_value(),
            "Tags": Match.array_with(
                Match.object_like({"Key": "HelloWorld", "Value": "true"})
            )
        }
    )

    # Assert SSM State Manager Association
    template.has_resource_properties(
        "AWS::SSM::Association",
        {
            "Name": Match.any_value(),
            "Targets": Match.array_with(
                Match.object_like({"Key": "tag:HelloWorld", "Values": ["true"]})
            )
        }
    )

    # Assert EventBridge Schedule
    template.has_resource_properties(
        "AWS::Scheduler::Schedule",
        {
            "FlexibleTimeWindow": Match.object_like({"Mode": "OFF"}),
            "ScheduleExpression": "rate(15 minutes)",
            "Target": Match.object_like({
                "Arn": Match.string_like_regexp(r".*ssm:SendCommand.*"),
                "RoleArn": Match.any_value()
            })
        }
    )

    # Assert IAM Role for EventBridge
    template.has_resource_properties(
        "AWS::IAM::Role",
        {
            "AssumeRolePolicyDocument": Match.object_like({
                "Statement": Match.array_with(
                    Match.object_like({
                        "Action": "sts:AssumeRole",
                        "Principal": Match.object_like({"Service": "scheduler.amazonaws.com"})
                    })
                )
            }),
            "ManagedPolicyArns": Match.array_with(
                Match.string_like_regexp(r".*AmazonSSMAutomationRole.*")
            )
        }
    )

    # Assert S3 bucket for logs
    template.has_resource_properties(
        "AWS::S3::Bucket",
        {}
    )

    # Assert Outputs exist
    template.has_output("InstanceIds")
    template.has_output("LogBucketName")
    template.has_output("ScheduleArn")