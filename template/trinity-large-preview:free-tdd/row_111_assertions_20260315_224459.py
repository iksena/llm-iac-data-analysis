def test_template(template: Template):
    # Assert EventBridge event bus
    template.has_resource_properties(
        "AWS::Events::EventBus",
        {
            "Name": "MyDataDogApp"
        }
    )

    # Assert API Destination
    template.has_resource_properties(
        "AWS::Events::ApiDestination",
        {
            "Name": "DataDogLogDestination",
            "ConnectionArn": Match.string_like_regexp(r"arn:aws:events:.+:.+:connection/.+"),
            "InvocationEndpoint": "https://http-intake.logs.datadoghq.com",
            "HttpMethod": "POST"
        }
    )

    # Assert Connection
    template.has_resource_properties(
        "AWS::Events::Connection",
        {
            "Name": "DataDogConnection",
            "AuthorizationType": "API_KEY",
            "ApiKeyAuthParameters": {
                "ApiKeyName": "DD-API-KEY",
                "ApiKeyValue": "testanu"
            }
        }
    )

    # Assert IAM Role for EventBridge
    template.has_resource_properties(
        "AWS::IAM::Role",
        {
            "AssumeRolePolicyDocument": {
                "Statement": [
                    {
                        "Action": "sts:AssumeRole",
                        "Effect": "Allow",
                        "Principal": {
                            "Service": "events.amazonaws.com"
                        }
                    }
                ],
                "Version": "2012-10-17"
            }
        }
    )

    # Assert SQS Dead Letter Queue
    template.has_resource_properties(
        "AWS::SQS::Queue",
        {
            "QueueName": "DataDogDeadLetterQueue"
        }
    )

    # Assert Rule
    template.has_resource_properties(
        "AWS::Events::Rule",
        {
            "EventBusName": "MyDataDogApp",
            "EventPattern": {
                "source": ["MyDataDogApp"]
            },
            "DeadLetterConfig": {
                "Arn": Match.string_like_regexp(r"arn:aws:sqs:.+:.+:DataDogDeadLetterQueue")
            }
        }
    )