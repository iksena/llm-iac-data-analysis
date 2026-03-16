def test_template(template: Template):
    # EventBridge event bus
    template.has_resource_properties(
        "AWS::Events::EventBus",
        {
            "Name": "CustomEventBus"
        }
    )

    # EventBridge API destination
    template.has_resource_properties(
        "AWS::Events::ApiDestination",
        {
            "Name": "CustomApiDestination",
            "ConnectionName": "CustomConnection",
            "InvocationEndpoint": "https://webhook.site/testtest",
            "HttpMethod": "POST"
        }
    )

    # EventBridge connection with API key authentication
    template.has_resource_properties(
        "AWS::Events::Connection",
        {
            "Name": "CustomConnection",
            "AuthorizationType": "API_KEY",
            "ApiKeyAuthParameters": {
                "ApiKeyName": "x-api-key",
                "ApiKeyValue": Match.string_like_regexp(".*")
            }
        }
    )

    # Verify counts
    template.resource_count_is("AWS::Events::EventBus", 1)
    template.resource_count_is("AWS::Events::ApiDestination", 1)
    template.resource_count_is("AWS::Events::Connection", 1)