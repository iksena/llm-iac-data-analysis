def test_template(template: Template):
    # Assert exactly one REST API exists
    template.resource_count_is("AWS::ApiGateway::RestApi", 1)

    # Assert exactly one Lambda function exists
    template.resource_count_is("AWS::Lambda::Function", 1)

    # Assert exactly one API Gateway Method exists
    template.resource_count_is("AWS::ApiGateway::Method", 1)

    # Assert exactly one API Gateway Integration exists
    template.resource_count_is("AWS::ApiGateway::Integration", 1)

    # Assert the Integration is non-proxy and points to the Lambda
    template.has_resource_properties("AWS::ApiGateway::Integration", {
        "IntegrationType": "AWS",
        "IntegrationHttpMethod": "POST",
        "Uri": Match.string_like_regexp("arn:aws:apigateway:.*lambda:path/2015-03-31/functions/arn:aws:lambda:.*")
    })

    # Assert the Method is attached to the REST API and points to the Integration
    template.has_resource_properties("AWS::ApiGateway::Method", {
        "HttpMethod": "ANY",
        "AuthorizationType": "NONE"
    })

    # Assert the Lambda has a permission to be invoked by API Gateway
    template.resource_count_is("AWS::Lambda::Permission", 1)

    # Assert the Lambda Permission is for API Gateway
    template.has_resource_properties("AWS::Lambda::Permission", {
        "Action": "lambda:InvokeFunction",
        "Principal": "apigateway.amazonaws.com"
    })