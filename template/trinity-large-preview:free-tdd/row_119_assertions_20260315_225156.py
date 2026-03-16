def test_template(template: Template):
    # Assert EventBridge event bus exists
    template.has_resource_properties("AWS::Events::EventBus", {
        "Name": "my-application"
    })

    # Assert Kinesis stream exists
    template.has_resource_properties("AWS::Kinesis::Stream", {
        "Name": "my-application-events"
    })

    # Assert IAM role for EventBridge to Kinesis permissions
    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": {
            "Statement": Match.array_with({
                "Principal": {
                    "Service": "events.amazonaws.com"
                }
            })
        },
        "Policies": Match.array_with({
            "PolicyDocument": {
                "Statement": Match.array_with({
                    "Effect": "Allow",
                    "Action": "kinesis:PutRecord",
                    "Resource": Match.string_like_regexp("arn:aws:kinesis:.*::.*:stream/my-application-events")
                })
            }
        })
    })

    # Assert EventBridge rule exists
    template.has_resource_properties("AWS::Events::Rule", {
        "EventBusName": "my-application",
        "Targets": Match.array_with({
            "Arn": Match.string_like_regexp("arn:aws:kinesis:.*::.*:stream/my-application-events"),
            "Id": "KinesisTarget"
        })
    })