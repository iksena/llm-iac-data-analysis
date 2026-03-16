def test_template(template: Template):
    # Assert S3 bucket exists
    template.resource_count_is("AWS::S3::Bucket", 1)

    # Assert Lambda functions exist (at least 2: one for Rekognition, one for SNS)
    template.resource_count_is("AWS::Lambda::Function", 2)

    # Assert Step Functions state machine exists
    template.resource_count_is("AWS::StepFunctions::StateMachine", 1)

    # Assert SNS topic exists
    template.resource_count_is("AWS::SNS::Topic", 1)

    # Assert IAM roles exist (at least 2: Lambda execution roles)
    template.resource_count_is("AWS::IAM::Role", 2)

    # Assert S3 bucket notification configuration exists
    template.has_resource_properties("AWS::S3::Bucket", {
        "NotificationConfiguration": {
            "LambdaConfigurations": Match.array_with({
                "Function": Match.string_like_regexp("arn:aws:lambda:")
            })
        }
    })

    # Assert Lambda permission for S3 trigger exists
    template.has_resource_properties("AWS::Lambda::Permission", {
        "Principal": "s3.amazonaws.com"
    })

    # Assert Step Functions state machine definition exists
    template.has_resource_properties("AWS::StepFunctions::StateMachine", {
        "DefinitionString": Match.string_like_regexp("Rekognition")
    })

    # Assert SNS topic subscription exists
    template.has_resource_properties("AWS::SNS::Subscription", {
        "Protocol": "sms"
    })

    # Assert IAM role for Lambda has Rekognition permissions
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": Match.object_like({
            "Statement": Match.array_with({
                "Effect": "Allow",
                "Action": "rekognition:*"
            })
        })
    })

    # Assert IAM role for Lambda has SNS permissions
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": Match.object_like({
            "Statement": Match.array_with({
                "Effect": "Allow",
                "Action": "sns:*"
            })
        })
    })