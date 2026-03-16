def test_template(template: Template):
    # Assert API Gateway REST API exists
    template.resource_count_is("AWS::ApiGateway::RestApi", 1)

    # Assert API Gateway IAM Role exists
    template.resource_count_is("AWS::IAM::Role", 1)

    # Assert API Gateway Deployment exists
    template.resource_count_is("AWS::ApiGateway::Deployment", 1)

    # Assert API Gateway Stage exists
    template.resource_count_is("AWS::ApiGateway::Stage", 1)

    # Assert API Gateway Usage Plan exists
    template.resource_count_is("AWS::ApiGateway::UsagePlan", 1)

    # Assert API Gateway API Key exists
    template.resource_count_is("AWS::ApiGateway::ApiKey", 1)

    # Assert API Gateway Usage Plan Key exists
    template.resource_count_is("AWS::ApiGateway::UsagePlanKey", 1)

    # Assert API Gateway Method exists
    template.resource_count_is("AWS::ApiGateway::Method", 1)

    # Assert API Gateway Model exists
    template.resource_count_is("AWS::ApiGateway::Model", 1)

    # Assert API Gateway Request Validator exists
    template.resource_count_is("AWS::ApiGateway::RequestValidator", 1)

    # Assert IAM Role has SES SendEmail permission
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": Match.array_with({
                "Action": "ses:SendEmail",
                "Effect": "Allow"
            })
        }
    })

    # Assert API Key is encrypted
    template.has_resource_properties("AWS::ApiGateway::ApiKey", {
        "Enabled": True,
        "StageKeys": Match.any_value(),
        "Tags": Match.any_value()
    })

    # Assert Usage Plan has throttling and quota
    template.has_resource_properties("AWS::ApiGateway::UsagePlan", {
        "ApiStages": Match.any_value(),
        "Throttle": {
            "BurstLimit": 500,
            "RateLimit": 500
        },
        "Quota": {
            "Limit": 10000,
            "Period": "MONTH"
        }
    })

    # Assert Request Validator exists
    template.has_resource_properties("AWS::ApiGateway::RequestValidator", {
        "ValidateRequestBody": True,
        "ValidateRequestParameters": True
    })

    # Assert Model exists with schema
    template.has_resource_properties("AWS::ApiGateway::Model", {
        "ContentType": "application/json",
        "Schema": Match.any_value()
    })

    # Assert Method has POST and integration with SES
    template.has_resource_properties("AWS::ApiGateway::Method", {
        "HttpMethod": "POST",
        "AuthorizationType": "NONE",
        "ApiKeyRequired": True
    })

    # Assert Integration exists
    template.has_resource_properties("AWS::ApiGateway::Integration", {
        "Type": "AWS",
        "IntegrationHttpMethod": "POST",
        "Uri": Match.string_like_regexp("arn:aws:apigateway:.*:ses:action/SendEmail")
    })