def test_template(template: Template):
    # Assert SQS Queue exists
    template.resource_count_is("AWS::SQS::Queue", 1)

    # Assert API Gateway REST API exists
    template.resource_count_is("AWS::ApiGateway::RestApi", 1)

    # Assert API Gateway Resource exists
    template.resource_count_is("AWS::ApiGateway::Resource", 1)

    # Assert API Gateway Method exists
    template.resource_count_is("AWS::ApiGateway::Method", 1)

    # Assert API Gateway Integration exists
    template.resource_count_is("AWS::ApiGateway::Integration", 1)

    # Assert IAM Role exists for API Gateway
    template.resource_count_is("AWS::IAM::Role", 1)

    # Assert SQS Queue Policy exists
    template.resource_count_is("AWS::SQS::QueuePolicy", 1)

    # Assert API Gateway has GET method
    template.has_resource_properties("AWS::ApiGateway::Method", {
        "HttpMethod": "GET",
        "AuthorizationType": "NONE"
    })

    # Assert API Gateway Integration is AWS service integration to SQS
    template.has_resource_properties("AWS::ApiGateway::Integration", {
        "IntegrationHttpMethod": "POST",
        "Type": "AWS",
        "IntegrationType": "AWS_PROXY"
    })

    # Assert SQS Queue Policy allows API Gateway to invoke ReceiveMessage
    template.has_resource_properties("AWS::SQS::QueuePolicy", {
        "PolicyDocument": {
            "Statement": Match.array_with({
                "Effect": "Allow",
                "Action": "SQS:ReceiveMessage"
            })
        }
    })

    # Assert IAM Role allows API Gateway to interact with SQS
    template.has_resource_properties("AWS::IAM::Role", {
        "AssumeRolePolicyDocument": {
            "Statement": Match.array_with({
                "Principal": {
                    "Service": "apigateway.amazonaws.com"
                }
            })
        }
    })