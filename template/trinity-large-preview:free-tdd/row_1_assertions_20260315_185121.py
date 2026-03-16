def test_template(template: Template):
    # Assert exactly one SNS topic exists
    template.resource_count_is("AWS::SNS::Topic", 1)

    # Assert the SNS topic has a subscription to the specified email
    template.has_resource_properties("AWS::SNS::Subscription", {
        "Endpoint": "test@test.com",
        "Protocol": "email"
    })

    # Optionally, if the business need requires an output for the topic ARN:
    # template.has_output("TopicArn", Match.object_like({
    #     "Value": Match.string_like_regexp("arn:aws:sns:")
    # }))