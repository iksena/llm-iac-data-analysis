def test_template(template: Template):
    # Assert SQS queue exists
    template.resource_count_is("AWS::SQS::Queue", 1)

    # Assert API Destination exists
    template.resource_count_is("AWS::ApiGateway::RestApi", 1)

    # Assert CloudWatch Log Group exists
    template.resource_count_is("AWS::Logs::LogGroup", 1)

    # Assert EventBridge Pipes resource exists
    template.resource_count_is("AWS::Events::Pipe", 1)

    # Assert IAM Role exists for EventBridge Pipes
    template.resource_count_is("AWS::IAM::Role", 1)

    # Assert the Pipe has the correct source (SQS)
    template.has_resource_properties("AWS::Events::Pipe", {
        "SourceParameters": {
            "SQS": {
                "QueueARN": Match.string_like_regexp("arn:aws:sqs:*:*:*")
            }
        }
    })

    # Assert the Pipe has the correct target (CloudWatch Logs)
    template.has_resource_properties("AWS::Events::Pipe", {
        "Target": {
            "LogGroup": {
                "LogGroupArn": Match.string_like_regexp("arn:aws:logs:*:*:log-group:*")
            }
        }
    })

    # Assert the Pipe has the correct API Destination
    template.has_resource_properties("AWS::Events::Pipe", {
        "Target": {
            "EndpointId": Match.string_like_regexp("arn:aws:events:*:*:endpoint/api/*")
        }
    })

    # Assert IAM Role has required permissions
    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": {
            "Statement": [{
                "Action": "sts:AssumeRole",
                "Effect": "Allow",
                "Principal": {
                    "Service": "events.amazonaws.com"
                }
            }]
        },
        "Policies": Match.array_with({
            "PolicyDocument": {
                "Statement": Match.array_with({
                    "Action": Match.array_with(
                        "sqs:ReceiveMessage",
                        "sqs:DeleteMessage",
                        "events:InvokeApiDestination"
                    ),
                    "Effect": "Allow",
                    "Resource": Match.any_value
                })
            }
        })
    })