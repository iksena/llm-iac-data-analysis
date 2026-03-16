def test_template(template: Template):
    # Assert EventBridge event bus exists
    template.resource_count_is("AWS::Events::EventBus", 1)

    # Assert EventBridge API destination exists
    template.resource_count_is("AWS::Events::ApiDestination", 1)

    # Assert EventBridge connection exists (for API key auth)
    template.resource_count_is("AWS::Events::Connection", 1)

    # Assert API key parameter exists
    template.has_parameter("StripeApiKey", Match.object_like({
        "Type": "AWS::SSM::Parameter::Value<String>"
    }))

    # Assert event bus has correct name and permissions
    template.has_resource_properties("AWS::Events::EventBus", {
        "Name": "PartnerApp"
    })

    # Assert API destination targets Stripe endpoint
    template.has_resource_properties("AWS::Events::ApiDestination", {
        "InvocationEndpoint": "https://api.stripe.com/v1/products",
        "HttpMethod": "POST"
    })

    # Assert connection uses API key auth
    template.has_resource_properties("AWS::Events::Connection", {
        "AuthorizationType": "API_KEY",
        "ApiKeyAuthParameters": {
            "ApiKeyName": "Authorization",
            "ApiKeyValue": Capture()
        }
    })

    # Assert API destination references the connection
    template.has_resource_properties("AWS::Events::ApiDestination", {
        "ConnectionArn": Capture()
    })