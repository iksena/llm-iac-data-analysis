def test_template(template: Template):
    # Assert S3 bucket with encryption
    template.has_resource_properties("AWS::S3::Bucket", {
        "BucketEncryption": Match.any_value(),
        "AccessControl": Match.any_value()
    })

    # Assert Lambda function with cross-account IAM role
    template.has_resource_properties("AWS::Lambda::Function", {
        "Handler": Match.any_value(),
        "Runtime": Match.any_value()
    })

    # Assert CloudWatch Events rule for weekly schedule
    template.has_resource_properties("AWS::Events::Rule", {
        "ScheduleExpression": Match.string_like_regexp("rate\\(7 days\\)")
    })

    # Assert Glue crawler with S3 target
    template.has_resource_properties("AWS::Glue::Crawler", {
        "DatabaseName": Match.any_value(),
        "Targets": {
            "S3Targets": [{
                "Path": Match.any_value()
            }]
        }
    })

    # Assert IAM role for Lambda with cross-account STS assume
    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": {
            "Statement": [{
                "Action": "sts:AssumeRole",
                "Effect": "Allow"
            }]
        },
        "Policies": [{
            "PolicyDocument": {
                "Statement": [{
                    "Action": "organizations:Describe*",
                    "Effect": "Allow"
                }]
            }
        }]
    })

    # Assert IAM role for Glue with S3 write access
    template.has_resource_properties("AWS::IAM::Role", {
        "Policies": [{
            "PolicyDocument": {
                "Statement": [{
                    "Action": "s3:Put*",
                    "Effect": "Allow"
                }]
            }
        }]
    })

    # Assert Parameters for customization
    template.has_parameter("S3BucketName", Match.any_value())
    template.has_parameter("ManagementAccountId", Match.any_value())
    template.has_parameter("AthenaDatabaseName", Match.any_value())
    template.has_parameter("TagsToInclude", Match.any_value())

    # Assert Outputs for resource ARNs
    template.has_output("LambdaFunctionArn", Match.any_value())
    template.has_output("GlueCrawlerArn", Match.any_value())
    template.has_output("S3BucketArn", Match.any_value())