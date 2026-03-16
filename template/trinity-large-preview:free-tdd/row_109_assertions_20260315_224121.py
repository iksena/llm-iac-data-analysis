def test_template(template: Template):
    # EventBridge event bus
    template.has_resource_properties(
        "AWS::Events::EventBus",
        {
            "Name": "default"
        }
    )

    # API Destination
    template.has_resource_properties(
        "AWS::Events::ApiDestination",
        {
            "ConnectionArn": Match.string_like_regexp(r"arn:aws:events:.+:.+:connection/.+"),
            "InvocationEndpoint": "www.testanu.com",
            "HttpMethod": "POST"
        }
    )

    # Connection with API key parameters
    template.has_resource_properties(
        "AWS::Events::Connection",
        {
            "ApiKeyAuthParameters": {
                "ApiKeyName": "test_name",
                "ApiKeyValue": "test_value"
            }
        }
    )

    # IAM Role for EventBridge
    template.has_resource_properties(
        "AWS::IAM::Role",
        {
            "AssumeRolePolicyDocument": {
                "Statement": [
                    {
                        "Principal": {
                            "Service": "events.amazonaws.com"
                        }
                    }
                ]
            }
        }
    )

    # Dead-letter SQS queue
    template.has_resource_properties(
        "AWS::SQS::Queue",
        {
            "RedrivePolicy": Match.object_like({
                "deadLetterTargetArn": Match.string_like_regexp(r"arn:aws:sqs:.+:.+:.+"),
                "maxReceiveCount": 3
            })
        }
    )

    # Ensure exactly one of each required resource type
    template.resource_count_is("AWS::Events::EventBus", 1)
    template.resource_count_is("AWS::Events::ApiDestination", 1)
    template.resource_count_is("AWS::Events::Connection", 1)
    template.resource_count_is("AWS::IAM::Role", 1)
    template.resource_count_is("AWS::SQS::Queue", 1)