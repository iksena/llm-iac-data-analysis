def test_template(template: Template):
    # Assert one API Gateway resource exists
    template.resource_count_is("AWS::ApiGatewayV2::Api", 1)

    # Assert one Lambda function exists
    template.resource_count_is("AWS::Lambda::Function", 1)

    # Assert one VPC endpoint exists
    template.resource_count_is("AWS::EC2::VPCEndpoint", 1)

    # Assert one API Gateway VPC link exists
    template.resource_count_is("AWS::ApiGatewayV2::VpcLink", 1)

    # Assert one API Gateway stage exists
    template.resource_count_is("AWS::ApiGatewayV2::Stage", 1)

    # Assert one custom domain name exists
    template.resource_count_is("AWS::ApiGatewayV2::DomainName", 1)

    # Assert one API Gateway integration exists
    template.resource_count_is("AWS::ApiGatewayV2::Integration", 1)

    # Assert one Lambda execution role exists
    template.resource_count_is("AWS::IAM::Role", 1)

    # Assert API Gateway has private endpoint configuration
    template.has_resource_properties("AWS::ApiGatewayV2::Api", {
        "EndpointConfiguration": {
            "VpcEndpointIds": Match.array_with(Match.string_like_regexp("vpce-"))
        }
    })

    # Assert Lambda has basic CloudWatch logging permissions
    template.has_resource_properties("AWS::IAM::Policy", {
        "PolicyDocument": {
            "Statement": Match.array_with({
                "Effect": "Allow",
                "Action": "logs:CreateLogGroup"
            })
        }
    })

    # Assert API Gateway integration points to Lambda
    template.has_resource_properties("AWS::ApiGatewayV2::Integration", {
        "IntegrationType": "AWS_PROXY",
        "IntegrationUri": Match.string_like_regexp("arn:aws:lambda:")
    })

    # Assert VPC endpoint is of type "Interface"
    template.has_resource_properties("AWS::EC2::VPCEndpoint", {
        "VpcEndpointType": "Interface"
    })

    # Assert custom domain name exists
    template.has_resource_properties("AWS::ApiGatewayV2::DomainName", {
        "DomainName": Match.string_like_regexp(".*")
    })

    # Assert stage is deployed
    template.has_resource_properties("AWS::ApiGatewayV2::Stage", {
        "AutoDeploy": True
    })