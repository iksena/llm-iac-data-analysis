def test_template(template: Template):
    # Assert S3 bucket exists
    template.resource_count_is("AWS::S3::Bucket", 1)

    # Assert Step Functions state machine exists
    template.resource_count_is("AWS::StepFunctions::StateMachine", 1)

    # Assert SNS topic exists
    template.resource_count_is("AWS::SNS::Topic", 1)

    # Assert Lambda function exists for bucket cleanup
    template.resource_count_is("AWS::Lambda::Function", 1)

    # Assert IAM roles exist
    template.resource_count_is("AWS::IAM::Role", 2)

    # Assert EventBridge rule exists
    template.resource_count_is("AWS::Events::Rule", 1)

    # Assert S3 bucket has notification configuration
    template.has_resource_properties("AWS::S3::Bucket", {
        "NotificationConfiguration": Match.object_like({
            "LambdaConfiguration": Match.array_with([Match.object_like({
                "Function": Capture(),
                "Event": "s3:ObjectCreated:*"
            })])
        })
    })

    # Assert Step Functions state machine has required permissions
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": Match.object_like({
            "Statement": Match.array_with([Match.object_like({
                "Action": Match.array_with([
                    "s3:GetObject",
                    "rekognition:DetectLabels",
                    "sns:Publish"
                ])
            })])
        })
    })

    # Assert SNS topic has subscription with correct phone number
    template.has_resource_properties("AWS::SNS::Subscription", {
        "Endpoint": "+14071113333",
        "Protocol": "sms"
    })

    # Assert EventBridge rule targets Step Functions
    template.has_resource_properties("AWS::Events::Rule", {
        "Targets": Match.array_with([Match.object_like({
            "Arn": Capture()
        })])
    })

    # Assert Lambda has S3 permissions for cleanup
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": Match.object_like({
            "Statement": Match.array_with([Match.object_like({
                "Action": Match.array_with([
                    "s3:ListBucket",
                    "s3:DeleteObject"
                ])
            })])
        })
    })