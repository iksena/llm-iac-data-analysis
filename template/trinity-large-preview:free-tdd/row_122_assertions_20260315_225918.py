def test_template(template: Template):
    # EventBridge event bus
    template.has_resource_properties(
        "AWS::Events::EventBus",
        {
            "Name": "MyShopifyApp"
        }
    )

    # API destination for Shopify product creation
    template.has_resource_properties(
        "AWS::Events::ApiDestination",
        {
            "Name": "ShopifyProductCreation",
            "ConnectionName": Match.string_like_regexp("ShopifyConnection.*"),
            "InvocationEndpoint": "https://testanu.myshopify.com/admin/api/2023-07/products.json",
            "HttpMethod": "POST"
        }
    )

    # Connection for Shopify API authentication
    template.has_resource_properties(
        "AWS::Events::Connection",
        {
            "Name": "ShopifyConnection",
            "AuthorizationType": "API_KEY",
            "ApiKeyAuthParameters": {
                "ApiKeyName": "X-Shopify-Access-Token",
                "ApiKeyValue": Match.string_like_regexp(".*")
            }
        }
    )

    # Rule to trigger API destination on events
    template.has_resource_properties(
        "AWS::Events::Rule",
        {
            "EventPattern": {
                "source": ["MyShopifyApp"]
            },
            "Targets": [
                {
                    "Arn": Match.string_like_regexp("arn:aws:events:.*:.*:api-destination/ShopifyProductCreation"),
                    "Id": "ShopifyProductCreationTarget"
                }
            ]
        }
    )

    # Parameter for Shopify admin API key
    template.has_parameter("ShopifyAdminApiKey")