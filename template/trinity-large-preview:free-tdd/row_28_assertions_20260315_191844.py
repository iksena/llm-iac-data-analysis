def test_template(template: Template):
    # Assert one EventBridge Rule for Secrets Manager events
    template.resource_count_is("AWS::Events::Rule", 1)

    # Assert one SNS Topic for notifications
    template.resource_count_is("AWS::SNS::Topic", 1)

    # Assert one SNS Topic Policy for EventBridge permissions
    template.resource_count_is("AWS::SNS::TopicPolicy", 1)

    # Assert the EventBridge Rule has the correct event pattern for Secrets Manager
    template.has_resource_properties("AWS::Events::Rule", {
        "EventPattern": {
            "source": ["aws.secretsmanager"],
            "detail-type": [
                "AWS API Call via CloudTrail",
                "Secrets Manager Secret State Change"
            ],
            "detail": {
                "eventSource": ["secretsmanager.amazonaws.com"],
                "eventName": ["CreateSecret", "UpdateSecret", "GetSecretValue"]
            }
        }
    })

    # Assert the SNS Topic Policy allows EventBridge to publish
    template.has_resource_properties("AWS::SNS::TopicPolicy", {
        "PolicyDocument": {
            "Statement": [{
                "Effect": "Allow",
                "Principal": {"Service": "events.amazonaws.com"},
                "Action": "SNS:Publish"
            }]
        }
    })