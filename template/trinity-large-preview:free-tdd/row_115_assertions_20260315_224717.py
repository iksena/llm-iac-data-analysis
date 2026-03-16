def test_template(template: Template):
    # Assert one EventBridge rule exists
    template.resource_count_is("AWS::Events::Rule", 1)

    # Assert one SNS topic exists
    template.resource_count_is("AWS::SNS::Topic", 1)

    # Assert EventBridge rule targets SNS topic
    template.has_resource_properties("AWS::Events::Rule", {
        "EventPattern": {
            "source": ["aws.secretsmanager"],
            "detail-type": ["AWS API Call via CloudTrail"]
        },
        "Targets": [{
            "Arn": Match.string_like_regexp("arn:aws:sns:.*:.*:.*"),
            "Id": Match.any_value()
        }]
    })

    # Assert SNS topic has subscription (email)
    template.has_resource_properties("AWS::SNS::Topic", {
        "Subscription": [{
            "Protocol": "email",
            "Endpoint": Match.any_value()
        }]
    })