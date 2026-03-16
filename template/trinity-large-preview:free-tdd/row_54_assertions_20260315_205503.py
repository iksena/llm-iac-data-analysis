def test_template(template: Template):
    # Assert exactly one SNS topic exists
    template.resource_count_is("AWS::SNS::Topic", 1)

    # Assert the SNS topic has the expected properties
    template.has_resource_properties("AWS::SNS::Topic", {
        "DisplayName": Match.any_value(),
        "Subscription": Match.any_value()
    })

    # Assert there is exactly one subscription
    template.resource_count_is("AWS::SNS::Subscription", 1)

    # Assert the subscription is for email protocol
    template.has_resource_properties("AWS::SNS::Subscription", {
        "Protocol": "email",
        "Endpoint": Match.any_value()
    })

    # Assert there is an output for the SNS topic ARN
    template.has_output("TopicArn", {
        "Value": Match.string_like_regexp("arn:aws:sns:.*:.*:.*")
    })