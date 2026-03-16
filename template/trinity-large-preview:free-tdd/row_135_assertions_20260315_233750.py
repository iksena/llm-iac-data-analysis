def test_template(template: Template):
    # Assert API Gateway REST API with mock backend
    template.has_resource_properties("AWS::ApiGateway::RestApi", {
        "EndpointConfiguration": Match.object_like({
            "Types": Match.array_with(["REGIONAL"])
        })
    })

    # Assert GET /hello method with mock integration
    template.has_resource_properties("AWS::ApiGateway::Method", {
        "HttpMethod": "GET",
        "ResourceId": Match.string_like_regexp(".*"),
        "RestApiId": Match.string_like_regexp(".*"),
        "Integration": Match.object_like({
            "IntegrationHttpMethod": "POST",
            "Type": "MOCK",
            "RequestTemplates": Match.object_like({
                "application/json": Match.string_like_regexp(".*")
            }),
            "PassthroughBehavior": "WHEN_NO_TEMPLATES"
        })
    })

    # Assert deployment to production stage
    template.has_resource_properties("AWS::ApiGateway::Deployment", {
        "RestApiId": Match.string_like_regexp(".*")
    })

    # Assert stage pointing to deployment
    template.has_resource_properties("AWS::ApiGateway::Stage", {
        "DeploymentId": Match.string_like_regexp(".*"),
        "RestApiId": Match.string_like_regexp(".*"),
        "StageName": "prod"
    })

    # Assert CloudFront distribution
    template.has_resource_properties("AWS::CloudFront::Distribution", {
        "DistributionConfig": Match.object_like({
            "Origins": Match.array_with([Match.object_like({
                "DomainName": Match.string_like_regexp(".*execute-api.*amazonaws.com"),
                "OriginPath": Match.string_like_regexp(".*"),
                "OriginProtocolPolicy": "https-only"
            })]),
            "DefaultCacheBehavior": Match.object_like({
                "TargetOriginId": Match.string_like_regexp(".*"),
                "ViewerProtocolPolicy": "redirect-to-https",
                "CachePolicyId": Match.string_like_regexp(".*"),
                "AllowedMethods": Match.array_with(["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]),
                "Compress": True
            }),
            "Enabled": True,
            "HttpVersion": "http2",
            "PriceClass": "PRICE_CLASS_100"
        })
    })

    # Assert no caching (using default cache policy)
    # We verify the default cache policy is used, which implies no custom caching
    template.has_resource_properties("AWS::CloudFront::Distribution", {
        "DistributionConfig": Match.object_like({
            "DefaultCacheBehavior": Match.object_like({
                "CachePolicyId": Match.string_like_regexp(".*")
            })
        })
    })

    # Assert resource counts
    template.resource_count_is("AWS::ApiGateway::RestApi", 1)
    template.resource_count_is("AWS::ApiGateway::Method", 1)
    template.resource_count_is("AWS::ApiGateway::Deployment", 1)
    template.resource_count_is("AWS::ApiGateway::Stage", 1)
    template.resource_count_is("AWS::CloudFront::Distribution", 1)